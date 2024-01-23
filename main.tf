module "compute" {
    source = "./modules/compute"

    az = var.az
    ami_id = var.ami_id
    inst_type = var.inst_type
}

