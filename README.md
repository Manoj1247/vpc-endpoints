``` mermaid
flowchart TD;
subgraph Internet 
       subgraph AWS
        style AWS fill:#FF9900
        subgraph vpcendpoint
            style vpcendpoint fill: #8F00FF
        end
            subgraph S3
            style S3 fill:#00FF00
            end
            subgraph VPC
                igw[Internet Gateway]
                subgraph private[Private Subnet]
                amazonec2[Elastic Cloud Compute]
                end
                subgraph public[Public Subnet]
                nat[Nat Gateway] 
                end
            end
            private --> vpcendpoint
            vpcendpoint --> S3
            public --> igw
            igw --> S3
        end
end
```