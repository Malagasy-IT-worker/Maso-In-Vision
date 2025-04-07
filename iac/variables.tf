variable "instances" {
    type = list(object({
         name = string
         port = number   
        }))
    default = [
        {name = "server-dev", port = 3000},
        {name = "server-prod", port = 80},
        {name = "server-runner", port = 9252}]
}
