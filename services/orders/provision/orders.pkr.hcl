
packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}

variable  "docker_repo" {
  type = string
  sensitive = true
}

variable  "docker_username" {
  type = string
  sensitive = true
}

variable "docker_password" {
  type = string
  sensitive = true
}
   
source "docker" "golang" {
  image       = "golang"
  commit      = true
  pull        = true
  changes = [
    "EXPOSE 8888 8888",
    "ENTRYPOINT [\"/bin/orders\"]"
  ]


}


build {
  sources = ["source.docker.golang"]

  provisioner "file" {
    source      = "../bin/orders"
    destination = "/bin/"
  }
  
  post-processors {
    post-processor "docker-tag" {
      repository = var.docker_repo
      tags       = ["1.0"]
    }

    post-processor "docker-push" {
      login=true
      login_username = var.docker_username
      login_password = var.docker_password
    }
  }  
}

