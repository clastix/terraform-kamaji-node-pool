# =============================================================================
# DATA SOURCES
# =============================================================================

data "vcd_catalog" "catalog" {
  name = var.vcd_catalog_name
  org  = var.vcd_catalog_org_name
}

data "vcd_catalog_vapp_template" "vapp_template" {
  catalog_id = data.vcd_catalog.catalog.id
  name       = var.vapp_template_name
}