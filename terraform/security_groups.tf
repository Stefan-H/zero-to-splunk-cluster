

resource "aws_security_group" "Splunk_All" {
  name        = "Splunk_All"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Splunk_All"
  }
}

resource "aws_security_group_rule" "allow_splunk_mgmt" {
  type                     = "ingress"
  from_port                = 8089
  to_port                  = 8089
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.Splunk_All.id
  security_group_id        = aws_security_group.Splunk_All.id
}

resource "aws_security_group_rule" "allow_splunk_idx_receive" {
  type                     = "ingress"
  from_port                = 9997
  to_port                  = 9997
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.Splunk_All.id
  security_group_id        = aws_security_group.Splunk_All.id
}

resource "aws_security_group_rule" "allow_splunk_idx_sync" {
  type                     = "ingress"
  from_port                = 9887
  to_port                  = 9887
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.Splunk_All.id
  security_group_id        = aws_security_group.Splunk_All.id
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.Splunk_All.id
}
