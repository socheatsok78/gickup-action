target "docker-metadata-action" {}


target "default" {
    inherits = ["docker-metadata-action"]
    args = {
      "GICKUP_VERSION" = "0.10.39"
      "GOMPLATE_VERSION" = "4.3.3"
    }
    platforms = [
        "linux/amd64",
        "linux/arm64",
    ]
}

target "dev" {
    args = {
      "GICKUP_VERSION" = "0.10.39"
      "GOMPLATE_VERSION" = "4.3.3"
    }
    tags = [
        "gickup-action:dev"
    ]
}
