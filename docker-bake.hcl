variable "GICKUP_VERSION" { default = "0.10.39" }
variable "GOMPLATE_VERSION" { default = "4.3.3" }

target "docker-metadata-action" {}

target "default" {
    inherits = ["docker-metadata-action"]
    args = {
      "GICKUP_VERSION" = GICKUP_VERSION
      "GOMPLATE_VERSION" = GOMPLATE_VERSION
    }
    platforms = [
        "linux/amd64",
        "linux/arm64",
    ]
}

target "dev" {
    args = {
      "GICKUP_VERSION" = GICKUP_VERSION
      "GOMPLATE_VERSION" = GOMPLATE_VERSION
    }
    tags = [
        "gickup-action:dev"
    ]
}
