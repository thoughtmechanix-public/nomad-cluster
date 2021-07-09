packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
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
  
  post-processor "docker-tag" {
    repository = "myrepo/orders"
    tags       = ["1.0"]
  }

  // post-processor "docker-push" {}
}

