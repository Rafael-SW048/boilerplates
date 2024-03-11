# Ubuntu Server Focal Docker
# ---
# Packer Template to create an Ubuntu Server (Focal) with Docker on VirtualBox

# Variable Definitions
variable "iso_url" {
    type = string
    default = "file:///C:/Users/Kyukirel/Downloads/Programs/ISO%20file/ubuntu-22.04.2-desktop-amd64.iso"
}

variable "iso_checksum" {
    type = string
    default = "sha256:B98DAC940A82B110E6265CA78D1320F1F7103861E922AA1A54E4202686E9BBD3"
}

source "virtualbox-iso" "ubuntu" {
    iso_url             = "${var.iso_url}"
    iso_checksum        = "${var.iso_checksum}"
    guest_os_type       = "Ubuntu_64"
  
    # PACKER Boot Commands
    # VM General Settings
    boot_command = [
        "<esc><wait>",
        "<esc><wait>",
        "<enter><wait180>",
        "<enter><wait5>",
        "<enter><wait5>",
        // "<down><wait><tab><down><enter><tab><tab><tab><enter><wait5>", // If want to install 3rd party software for graphics and Wi-Fi hardware and additional media formats
        "<down><tab><down><tab><tab><tab><enter><wait10>", // If not (Minimal Installation)
        "<tab><tab><tab><tab><enter><wait10>",
        "<tab><enter><wait30>",
        "<tab><tab><tab><enter><wait5>",
        "test<tab>test<tab>test<tab>test123<tab>test123<tab><up><tab><tab><enter><wait210>",
        // "<tab><tab><enter><wait240>", // Skip installation
        "<tab><enter><wait30>",
    ]

    // boot_command = [
    //     "<esc><wait>",
    //     "<esc><wait>",
    //     "<enter><wait>",
    //     "/install/vmlinuz<wait>",
    //     " auto=true<wait>",
    //     " priority=critical<wait>",
    //     " locale=en_US<wait>",
    //     " console-setup/layoutcode=us<wait>",
    //     " keyboard-configuration/layout=USA<wait>",
    //     " keymap=us<wait>",
    //     " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<wait>",
    //     " debian-installer=en_US<wait>",
    //     " auto-install/enable=true<wait>",
    //     " hostname=ubuntu<wait>",
    //     " fb=false<wait>",
    //     " debconf/frontend=noninteractive<wait>",
    //     " console=ttyS0<wait>",
    //     "<enter><wait>"
    // ]

    boot_wait = "10s"

    # PACKER Autoinstall Settings
    disk_size           = 20000
    headless            = false
    http_directory      = "http"

    # (Optional) Bind IP Address and Port
    // http_bind_address = "0.0.0.0"
    // http_port_min = 8802
    // http_port_max = 8802

    ssh_username        = "ubuntu"
    ssh_password        = "password"
    ssh_port            = 22
    ssh_wait_timeout    = "20m"
    // type                = "debian" // error: unknown variable

    vboxmanage          = [
        [ "modifyvm", "{{.Name}}", "--memory", "2048" ],
        [ "modifyvm", "{{.Name}}", "--cpus", "1" ],
        // [ "modifyvm", "{{.Name}}", "--chipset", "ich9" ],
        // [ "modifyvm", "{{.Name}}", "--firmware", "EFI" ],
        [ "modifyvm", "{{.Name}}", "--natdnshostresolver1", "on" ]
    ]

    // virtualbox_version  = "{{ user `virtualbox_version` }}" // error: unknown variable

    vm_name             = "ubuntu-vm"
    shutdown_command    = "echo 'password' | sudo -S shutdown -P now"
}

# Build Definition to create the VM Template
build {
    name = "ubuntu-desktop-docker"
    sources = ["source.virtualbox-iso.ubuntu"]

    # Builder Configuration
    provisioner "shell" {
        inline = [
            "set -e",
            "echo 'Updating and upgrading apt packages...'",
            "sudo apt-get update",
            "sudo apt-get upgrade -y",
            "echo 'Installing necessary packages...'",
            "sudo apt-get install -y build-essential",
            "echo 'Installing Docker...'",
            "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
            "sudo add-apt-repository -y \"deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable\"",
            "sudo apt-get update",
            "sudo apt-get install -y docker-ce docker-ce-cli containerd.io"
        ]
    }
}