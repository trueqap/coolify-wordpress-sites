# Coolify WordPress Sites

Monorepo WordPress oldalak kezeléséhez Coolify-val.

## Struktúra

```
coolify-wordpress-sites/
├── shared/                      # Közös konfigurációs fájlok
│   ├── docker-compose.base.yml  # Alap template
│   ├── nginx-base.conf          # Nginx alap konfig
│   └── php-base.ini             # PHP alap konfig
├── sites/                       # Egyedi oldalak
│   ├── demo-cpx21/              # demo-cpx21.hellowp.cloud
│   │   ├── docker-compose.yml
│   │   ├── nginx.conf
│   │   └── php-custom.ini
│   └── another-site/            # másik oldal...
└── README.md
```

## Új site létrehozása

1. Másold a `shared/docker-compose.base.yml` fájlt `sites/SITENEV/docker-compose.yml`-be
2. Másold a `shared/nginx-base.conf` fájlt `sites/SITENEV/nginx.conf`-ba
3. Másold a `shared/php-base.ini` fájlt `sites/SITENEV/php-custom.ini`-be
4. Cseréld ki:
   - `SITENAME` → egyedi site azonosító (pl. `shop-cpx21`)
   - `DOMAIN` → teljes domain (pl. `shop-cpx21.hellowp.cloud`)
5. Push a GitHub-ra
6. Coolify-ban hozd létre az alkalmazást `base_directory: /sites/SITENEV` paraméterrel

## Coolify API hívás

```bash
curl -s -X POST "http://cmain.hellowp.cloud:8000/api/v1/applications/dockercompose" \
  -H "Authorization: Bearer $COOLIFY_API_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{
    "project_uuid": "PROJECT_UUID",
    "server_uuid": "SERVER_UUID",
    "environment_name": "production",
    "git_repository": "https://github.com/trueqap/coolify-wordpress-sites",
    "git_branch": "main",
    "base_directory": "/sites/demo-cpx21",
    "name": "demo-cpx21",
    "instant_deploy": false
  }'
```

## Erőforrás limitek (CPX21 - 3 vCPU, 4GB RAM)

| Szolgáltatás | CPU Limit | Memory Limit |
|--------------|-----------|--------------|
| WordPress/PHP-FPM | 1.0 | 512M |
| Nginx | 0.5 | 128M |
| MariaDB | 1.0 | 1G |
| Redis | 0.25 | 256M |

## Stack

- WordPress PHP 8.3 FPM Alpine
- Nginx with FastCGI cache
- MariaDB 11.4 (optimized)
- Redis 7 Alpine (object cache)
- Traefik (SSL via Let's Encrypt)
