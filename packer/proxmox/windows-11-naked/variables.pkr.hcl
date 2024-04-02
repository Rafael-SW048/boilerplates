vm_name = "Win10x64-VM-template"
template_description = "Windows 11 64-bit Pro template built with Packer"
proxmox_skip_tls_verify = true
iso_file = "local:iso/Windows 11 Pro 23H2 Build 22631.2715 (No TPM Required) Preactivated.iso"
// iso_checksum = "C299F39A120EFAAEAFC4802C854CD67634643205D8272A4CF16B649277C07A12"
vm_cpu_cores = "4"
vm_memory = "2048"
vm_disk_size = "50G"

winrm_username = "admin"
winrm_password = "admin"
