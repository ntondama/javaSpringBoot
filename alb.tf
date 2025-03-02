# ✅ Create ALB
resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets           = aws_subnet.public[*].id

  tags = {
    Name = "MyALB"
  }
}

# ✅ Create Target Groups
resource "aws_lb_target_group" "tg" {
  count   = 3
  name    = "tg-${count.index + 1}"
  port    = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "instance"
}

# ✅ Attach EC2 instances to Target Groups
resource "aws_lb_target_group_attachment" "attach" {
  count            = 3
  target_group_arn = aws_lb_target_group.tg[count.index].arn
  target_id        = aws_instance.servers[count.index].id
}

# ✅ ALB Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Invalid Path"
      status_code  = "404"
    }
  }
}

# ✅ Path-based Routing Rules
resource "aws_lb_listener_rule" "server1" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = 10

  conditions {
    field  = "path-pattern"
    values = ["/server1"]
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[0].arn
  }
}
