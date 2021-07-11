job "orders-job" {
  datacenters = ["cary"]
  type = "service"
  update {
    stagger      = "30s"
    max_parallel = 1
  }
  group "orders-group" {
  
    count = 3

    task "orders-task" {
      driver = "docker"

      config {
        image = "johncarnell/orders:1.0"

        port_map {
          http = 8888
        }
      }

      service {
        # This tells Consul to monitor the service on the port
        # labelled "http". Since Nomad allocates high dynamic port
        # numbers, we use labels to refer to them.
        port = "http"

        check {
          type     = "http"
          path     = "/healthcheck"
          interval = "10s"
          timeout  = "2s"
        }
      }

      resources {
        cpu    = 500 # MHz
        memory = 128 # MB

        network {
          mbits = 100

         
          port "http" {}
      

         
        }
      }
    }
  }
}