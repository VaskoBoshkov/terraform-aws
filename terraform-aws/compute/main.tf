# --- compute/main.tf ---

data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

resource "random_id" "dev_instance_id" {
  byte_length = 2
  count       = var.instance_count
  #   ke se smene vrednosta na random_id koga ke se smene key_name
  keepers = {
    key_name = var.key_name
  }
}

resource "aws_key_pair" "dev_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "dev_instance" {
  count         = var.instance_count # 1
  instance_type = var.instance_type  # t2.micro
  ami           = data.aws_ami.server_ami.id

  tags = {
    Name = "dev_instance-${random_id.dev_instance_id[count.index].dec}"
  }
  key_name               = aws_key_pair.dev_auth.id
  vpc_security_group_ids = var.public_sg
  subnet_id              = var.public_subnets[count.index]

  root_block_device {
    volume_size = var.vol_size # 10
  }
}

resource "aws_lb_target_group_attachment" "dev_tg_attach" {
  count            = var.instance_count
  target_group_arn = var.lb_target_group_arn
  target_id        = aws_instance.dev_instance[count.index].id
  port             = var.tg_port #8000
}