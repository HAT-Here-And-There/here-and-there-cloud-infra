locals {
  backend_service_list = ["user"]
}

resource "aws_ecrpublic_repository" "ecr" {
  count = length(local.backend_service_list)

  provider = aws.us_east_1

  repository_name = format(module.naming.result, "ecr-${local.backend_service_list[count.index]}")

  catalog_data {
    architectures     = ["x86_64"]
    description       = "backend image for ${local.backend_service_list[count.index]}"
    operating_systems = ["Linux"]
  }
}
