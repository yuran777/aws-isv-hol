resource "vault_auth_backend" "userpass" {
  type      = "userpass"

  provisioner "local-exec" {
    command = "kubectl exec -it -n vault vault-0 -- vault write auth/userpass/users/jenkins password=jenkinspwd policies=jenkinscreds"
  }
  depends_on = [ vault_policy.jenkins_auth_policy ]
}