# Packer Configuration for Windows 11

# Packer plugin for Proxmox
packer {
  required_plugins {
    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

# Variable Definitions
variable "proxmox_api_url" {
    type = string
}

variable "proxmox_api_token_id" {
    type = string
}

variable "proxmox_host" {
    type = string
    default ="pve"
}

variable "proxmox_api_token_secret" {
    type = string
}

variable "proxmox_skip_tls_verify" {
    type = bool
}

variable "winrm_username" {
    type = string
}

variable "winrm_password" {
    type = string
}

variable "vm_name" {
    type = string
}

variable "template_description" {
    type = string
}

variable "iso_file" {
    description = "The path to the ISO file"
    type = string
    default = "your-iso-file"
}

// variable "iso_checksum" {
//   description = "The checksum of the ISO windows file"
//   type        = string
//   default     = "sha256:C299F39A120EFAAEAFC4802C854CD67634643205D8272A4CF16B649277C07A12"
// }

variable "vm_cpu_cores" {
    type = string
}

variable "vm_memory" {
    type = string
}

variable "vm_disk_size" {
    type = string
}

source "proxmox-iso" "windows-11-naked" {
    # Proxmox Connection Settings
    proxmox_url = "${var.proxmox_api_url}"
    username = "${var.proxmox_api_token_id}"
    token = "${var.proxmox_api_token_secret}"
    node = "${var.proxmox_host}"
    # (Optional) Skip TLS Verification
    insecure_skip_tls_verify = "${var.proxmox_skip_tls_verify}"

    # VM General Settings
    // vm_id = "500"
    vm_name = "${var.vm_name}"
    template_description = "${var.template_description}"

    iso_file = "${var.iso_file}"
    // iso_checksum = "${var.iso_checksum}"
    iso_checksum = "C299F39A120EFAAEAFC4802C854CD67634643205D8272A4CF16B649277C07A12"
    // iso_storage_pool = "local"
    unmount_iso = true

    # VM System Settings
    qemu_agent = true
    
    cores = "${var.vm_cpu_cores}"
    os = "win11"

    network_adapters {
            model = "e1000"
            bridge = "vmbr0"
            vlan_tag = "102"
            firewall = "false"
    }

    # VM Hard Disk Settings
    disks {
        type = "sata"
        disk_size = "${var.vm_disk_size}"
        storage_pool = "local-lvm"
        format = "qcow2"
    }

    http_directory = "http"
    additional_iso_files {
        device = "sata3"
        // iso_url = "./auto/Autounattend.iso"
        iso_file = "local:iso/Autounattend.iso"
        iso_checksum = "0D9B478536670B4767EDC5C93CF3182F0EBF37BD653AE7B462AD55D3DEB0A4AA"
        // iso_storage_pool = "local"
        unmount = true
    }

    additional_iso_files {
        device = "sata4"
        // iso_url = "./auto/virtio-win-0.1.248.iso"
        iso_file = "local:iso/virtio-win-0.1.248.iso"
        iso_checksum = "D5B5739CF297F0538D263E30678D5A09BBA470A7C6BCBD8DFF74E44153F16549"
        // iso_storage_pool = "local"
        unmount = true
    }

    communicator = "winrm"
    winrm_username = "${var.winrm_username}"
    winrm_password = "${var.winrm_password}"
    winrm_insecure = true
    winrm_use_ssl = true
}

build {
    name = "windows-11-naked"
    sources = ["source.proxmox-iso.windows-11-naked"]

    provisioner "windows-shell" {
        scripts = [
            "scripts/disablewinupdate.bat"
        ]
    }


    provisioner "powershell" {
        scripts = [
            "scripts/install_cloudbase-init.ps1"
        ]
    }
}