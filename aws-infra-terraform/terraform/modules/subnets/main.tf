data "aws_availability_zones" "available" {}

locals {
  azs = length(var.azs) > 0 ? var.azs : slice(data.aws_availability_zones.available.names, 0, 2)

  public = { for i, cidr in var.public_cidrs :
    i => {
      cidr = cidr
      az   = local.azs[i]
    }
  }
  app = { for i, cidr in var.app_cidrs :
    i => {
      cidr = cidr
      az   = local.azs[i]
    }
  }
  data = { for i, cidr in var.data_cidrs :
    i => {
      cidr = cidr
      az   = local.azs[i]
    }
  }
}

resource "aws_subnet" "public" {
  for_each          = local.public
  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags = {
    Name = "${var.project}-public-${each.key}"
    Tier = "public"
  }
}
resource "aws_subnet" "app" {
  for_each          = local.app
  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags = {
    Name = "${var.project}-app-${each.key}"
    Tier = "app"
  }
}
resource "aws_subnet" "data" {
  for_each          = local.data
  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags = {
    Name = "${var.project}-data-${each.key}"
    Tier = "data"
  }
}
