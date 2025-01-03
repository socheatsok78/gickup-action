target "docker-metadata-action" {}


target "default" {
    inherits = ["docker-metadata-action"]
    platforms = [
        "linux/amd64",
        "linux/arm64",
    ]
}

target "dev" {
    tags = [
        "gickup-action:dev"
    ]
}
