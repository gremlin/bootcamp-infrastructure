output "environment_count" {
    value = length(module.k8s_envs)
}

output "k8s_credentials" {
    value = [ for env in module.k8s_envs:
        {
            endpoint = env.cluster_endpoint
            token = env.cluster_token
            cluster_certificate = env.cluster_certificate
        }
    ]
}