# terraform-aviatrix-network-domain-module
Allows to define network domains and build policy in a simplified way


## Example 1 - strict_mode = true
In strict mode if you want to allow traffic between domainX and domainY you need to list domainX under domainY and vice versa. DomainY needs to be listed under domainX. 
```hcl
module "my_network_domains" {
  source          = "github.com/conip/terraform-aviatrix-network-domain-module"
  strict_mode     = true
  network_domains = {
      "domain1" = ["domain2","domain3","domain4","domain5","domain6","domain7","domain8","domain9"],
      "domain2" = ["domain1","domain3","domain8"],
      "domain3" = ["domain1","domain2","domain8","domain6"],
      "domain4" = ["domain5","domain6"],
      "domain5" = ["domain4","domain1"],
      "domain6" = ["domain1","domain4","domain3"],
      "domain7" = [],
      "domain8" = ["domain3","domain2"],
      "domain9" = []
  }
}
```
policy between domain1 and domain9 or 7 will not be created as 7,9 don't have 1 listed	
<br>All 9 domains will be created with 7 and 9 not allowed to talk to any other. 

## Example 2 - strict_mode = false
Here policy will be built if there is just one pair defined. 
```hcl
module "my_network_domains" {
  source          = "github.com/conip/terraform-aviatrix-network-domain-module"
  strict_mode     = false
  network_domains = {
      "domain1" = ["domain2","domain3","domain4"],
      "domain2" = ["domain3","domain4"],
      "domain3" = [],
      "domain4" = []
  }

  associations = {
    "spoke1" = "domain1",
    "vpn1"   = "domain2",
  }
}
}
```
There will be connection policy between 1-2, 1-3, 1-4, 2-3, 2-4
