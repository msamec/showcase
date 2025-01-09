

# Description

The purpose of this application is to use popular and often-used DevOps tools and principles, bringing them together in cohesion to demonstrate how you can easily automate testing, generate changelogs, deploy to a Kubernetes (K9s) infrastructure, and much more.

## Disclaimer

Some aspects of this application have been simplified for the purpose of better presentation. In a real production environment, certain implementations might differ to adhere to best practices and specific requirements.

# Infrastructure

This application leverages a variety of technologies and principles to create a cohesive DevOps environment. Below is a list of the key technologies and principles used:

# Technologies

   * GitHub Actions: For continuous integration and automation of workflows.
   * GitHub Registry: For managing Docker images.
   *  Docker: For containerizing applications.
   * Kubernetes: For orchestrating containerized applications, including components like:
     * NGINX Ingress: For managing external access to services in the cluster.
     * MetalLB: For providing network load balancing.
     * Cert-Manager: For managing SSL/TLS certificates.
     *  Sealed Secrets: For securely managing secrets.
   * Helm: For managing Kubernetes applications.
   * Ansible: For automating configuration management and application deployment.
   * ArgoCD: For continuous deployment and managing GitOps workflows.
     * Keycloak: For identity and access management.
   * Prometheus: For monitoring and alerting.
   * Grafana: For visualizing monitoring data.

# Principles

   * Conventional Commits: For maintaining a consistent commit history and automating versioning.
