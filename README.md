# Coolify WordPress Sites

Monorepo WordPress oldalak kezeléséhez Coolify-val, szerver mérethez optimalizált konfigurációkkal.

## Struktúra

```
coolify-wordpress-sites/
├── shared/                      # Közös konfigurációs fájlok
│   ├── docker-compose.base.yml  # Alap template
│   ├── nginx-base.conf          # Nginx alap konfig
│   └── php-base.ini             # PHP alap konfig
├── sites/                       # Egyedi oldalak
│   ├── demo-cpx22/              # 2 vCPU, 4GB RAM
│   ├── demo-cpx32/              # 4 vCPU, 8GB RAM
│   ├── demo-cpx42/              # 8 vCPU, 16GB RAM
│   ├── demo-cpx52/              # 12 vCPU, 24GB RAM
│   └── demo-cpx62/              # 16 vCPU, 32GB RAM
└── README.md
```

## Szerver konfigurációk

| Szerver | vCPU | RAM | SSD | Domain |
|---------|------|-----|-----|--------|
| CPX22 | 2 | 4GB | 80GB | demo-cpx22.hellowp.cloud |
| CPX32 | 4 | 8GB | 160GB | demo-cpx32.hellowp.cloud |
| CPX42 | 8 | 16GB | 320GB | demo-cpx42.hellowp.cloud |
| CPX52 | 12 | 24GB | 480GB | demo-cpx52.hellowp.cloud |
| CPX62 | 16 | 32GB | 640GB | demo-cpx62.hellowp.cloud |

## Erőforrás limitek szerver méret szerint

### CPX22 (2 vCPU, 4GB RAM)
| Szolgáltatás | CPU Limit | Memory Limit | InnoDB Buffer |
|--------------|-----------|--------------|---------------|
| WordPress | 0.75 | 384M | - |
| Nginx | 0.25 | 96M | - |
| MariaDB | 0.75 | 768M | 512M |
| Redis | 0.25 | 160M | 128M |

### CPX32 (4 vCPU, 8GB RAM)
| Szolgáltatás | CPU Limit | Memory Limit | InnoDB Buffer |
|--------------|-----------|--------------|---------------|
| WordPress | 1.5 | 768M | - |
| Nginx | 0.5 | 192M | - |
| MariaDB | 1.5 | 1.5G | 1G |
| Redis | 0.5 | 320M | 256M |

### CPX42 (8 vCPU, 16GB RAM)
| Szolgáltatás | CPU Limit | Memory Limit | InnoDB Buffer |
|--------------|-----------|--------------|---------------|
| WordPress | 3.0 | 1.5G | - |
| Nginx | 1.0 | 384M | - |
| MariaDB | 3.0 | 5G | 4G |
| Redis | 1.0 | 640M | 512M |

### CPX52 (12 vCPU, 24GB RAM)
| Szolgáltatás | CPU Limit | Memory Limit | InnoDB Buffer |
|--------------|-----------|--------------|---------------|
| WordPress | 4.0 | 2G | - |
| Nginx | 2.0 | 512M | - |
| MariaDB | 4.0 | 10G | 8G |
| Redis | 2.0 | 1G | 768M |

### CPX62 (16 vCPU, 32GB RAM)
| Szolgáltatás | CPU Limit | Memory Limit | InnoDB Buffer |
|--------------|-----------|--------------|---------------|
| WordPress | 6.0 | 3G | - |
| Nginx | 2.0 | 768M | - |
| MariaDB | 6.0 | 16G | 12G |
| Redis | 2.0 | 1.3G | 1G |

## Coolify API hívás

```bash
# Példa: demo-cpx32 létrehozása a cpx32 szerveren
curl -s -X POST "https://cmain.hellowp.cloud/api/v1/applications/dockercompose" \
  -H "Authorization: Bearer $COOLIFY_API_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{
    "project_uuid": "PROJECT_UUID",
    "server_uuid": "ng00s0ckcgwswocg0swogwc4",
    "environment_name": "production",
    "git_repository": "https://github.com/trueqap/coolify-wordpress-sites",
    "git_branch": "main",
    "base_directory": "/sites/demo-cpx32",
    "name": "demo-cpx32",
    "instant_deploy": false
  }'
```

## Szerver UUID-k

| Szerver | UUID |
|---------|------|
| cpx22 | x8oc48k8gok4sok84wcs0cww |
| cpx32 | ng00s0ckcgwswocg0swogwc4 |
| cpx42 | lowc0cwkssk8ogkskkogs04w |
| cpx52 | wwkcgksss4gossksg0sokg8c |
| cpx62 | hg4s00ocwo8gcw8gw84osww8 |

## Stack

- WordPress PHP 8.3 FPM Alpine
- Nginx with FastCGI cache
- MariaDB 11.4 (optimized per server size)
- Redis 7 Alpine (object cache)
- Traefik (SSL via Let's Encrypt)

## Optimalizációk

- **PHP**: OPcache JIT, memory limit, realpath cache - méretezve szerver RAM-hoz
- **Nginx**: FastCGI cache, gzip, worker processes - méretezve vCPU-hoz
- **MariaDB**: InnoDB buffer pool (60-70% RAM), query cache, connection limits
- **Redis**: maxmemory allkeys-lru policy
