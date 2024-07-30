locals {
  network_domains_set = toset(keys(var.network_domains))
  create_domain = length(local.network_domains_set) > 0 ? true : false
  create_policy = length(local.policy) > 0 ? true : false

  policy = var.strict_mode ? toset(flatten([
    for domain, values in var.network_domains : [
      for value in values : 
      "${sort([value, domain])[0]}~${sort([value,domain])[1]}" 
      if try(contains(var.network_domains[value], domain), false)
    ]
  ])) : toset(flatten([
    for domain, values in var.network_domains : [
      for value in values : 
      "${sort([value, domain])[0]}~${sort([value,domain])[1]}" 
    ]
  ]))
}
#------------------------------------------- resources -----------------------------------------
resource "aviatrix_segmentation_network_domain" "segmentation_network_domain" {
  for_each    = local.create_domain ? local.network_domains_set : toset([])
  domain_name = each.key
}

resource "aviatrix_segmentation_network_domain_connection_policy" "domain_policy" {
  for_each      = local.create_policy ? local.policy : toset([])
  domain_name_1 = trimspace(split("~", each.key)[0])
  domain_name_2 = trimspace(split("~", each.key)[1])
  depends_on = [ aviatrix_segmentation_network_domain.segmentation_network_domain ]
}
