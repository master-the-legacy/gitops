resource "aws_ecr_repository" "legacy-ecr-repo" {
  name                 = "legacy-ecr-repo"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    product = "master-the-legacy"
    ctf     = "-. .. -.-. . -.-.-- / .. ..-. / -.-- --- ..- / ..- ... . -.. / -.-. .... .- - --. .--. - / - .... .- - .----. ... / ... .- -.. -.-.-- / .. ..-. / -. --- - / -. .. -.-. . / -.-. .- - -.-. .... -.-.--"
  }
}
