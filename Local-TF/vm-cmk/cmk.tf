resource "azurerm_key_vault_key" "cmk" {
  count        = var.secret_data ? 1 : 0
  name         = join("-", [local.vm_name, "des", "cmk"])
  key_vault_id = azurerm_key_vault.disks.id
  key_type     = var.cmk_key_type
  key_size     = var.cmk_key_size

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
  depends_on = [azurerm_key_vault.disks]
}

resource "azurerm_disk_encryption_set" "des" {
  count                     = var.secret_data ? 1 : 0
  name                      = join("-", [local.vm_name, "des", "cmk"])
  resource_group_name       = azurerm_resource_group.disks.name
  location                  = azurerm_resource_group.disks.location
  key_vault_key_id          = azurerm_key_vault_key.cmk.0.id
  auto_key_rotation_enabled = true

  identity {
    type = "SystemAssigned"
  }
  depends_on = [azurerm_key_vault.disks]
}

resource "azurerm_key_vault_access_policy" "des_access_policy" {
  count        = var.secret_data ? 1 : 0
  key_vault_id = azurerm_key_vault.disks.id

  tenant_id = azurerm_disk_encryption_set.des[0].identity.0.tenant_id
  object_id = azurerm_disk_encryption_set.des[0].identity.0.principal_id

  key_permissions = [
    "Get",
    "List",
    "UnwrapKey",
    "WrapKey"
  ]
  depends_on = [
    azurerm_disk_encryption_set.des
  ]
}

resource "azurerm_role_assignment" "des_role_assigment" {
  count                = var.secret_data ? 1 : 0
  scope                = azurerm_key_vault.disks.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_disk_encryption_set.des[0].identity.0.principal_id
  depends_on = [
    azurerm_disk_encryption_set.des
  ]
}
