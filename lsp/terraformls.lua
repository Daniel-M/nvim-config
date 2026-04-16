-- lsp/terraformls.lua — Terraform Language Server
-- Install: brew install hashicorp/tap/terraform-ls
return {
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "terraform-vars", "hcl" },
  root_markers = { ".terraform", "*.tf", ".git" },
}
