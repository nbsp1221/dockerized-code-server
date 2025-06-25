# Dockerized code-server

A complete Docker-based code-server setup using LinuxServer.io image with Caddy reverse proxy for authentication and automatic HTTPS.

## Quick Start

1. **Setup Environment**:
   ```bash
   cp .env.example .env
   # Edit .env with your values
   ```

2. **Generate Password Hash**:
   ```bash
   ./hash-password.sh "your-password"
   # Copy the hash to AUTH_PASSWORD_HASH in .env
   ```

3. **Start Services**:
   ```bash
   docker-compose up -d
   ```

4. **Access**:
   - Local: http://code-server.localhost (or your DOMAIN)
   - Production: https://your-domain.com

## Features

- 🔐 **Secure Authentication**: Caddy Basic Auth with bcrypt password hashing
- 🔒 **SSL/HTTPS Support**: Automatic HTTPS with Let's Encrypt
- 🚀 **Service Worker Support**: Properly configured to handle VS Code service workers
- 🐳 **Docker Integration**: Docker-in-Docker support for development
- 📦 **LinuxServer Image**: Uses stable LinuxServer.io code-server image
- ⚡ **Minimal Setup**: Simple .env configuration

## Configuration

### Environment Variables (.env)

```bash
# Domain Configuration
DOMAIN=code-server.localhost
HTTP_PORT=80
HTTPS_PORT=443

# Authentication (for Caddy Basic Auth)
AUTH_USERNAME=admin
AUTH_PASSWORD_HASH=your-bcrypt-hash

# Code-Server Sudo Password
SUDO_PASSWORD=your-sudo-password
```

### Directory Structure

```
dockerized-code-server/
├── docker-compose.yaml     # Main orchestration
├── Caddyfile              # Caddy configuration
├── hash-password.sh       # Password hash generator
├── .env.example          # Environment template
├── .env                  # Your environment (gitignored)
└── code-server/          # Code-server data
    └── workspace/        # Your workspace
```

## Usage

### Password Management

Generate a new password hash:
```bash
./hash-password.sh "mynewpassword"
```

Update your `.env` file:
```bash
AUTH_PASSWORD_HASH=your-generated-hash
```

### Docker Commands

```bash
# View all service logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f code-server
docker-compose logs -f caddy

# Restart services
docker-compose restart

# Stop services
docker-compose down

# Update images
docker-compose pull && docker-compose up -d

# Access code-server container
docker-compose exec code-server bash
```

## Troubleshooting

### Service Worker Errors
- VS Code service workers are configured to bypass authentication
- Ensure `/stable-*/static/*` paths work without auth

### Connection Issues
- Check if ports are available: `netstat -tlnp | grep :80`
- Verify environment variables in `.env`
- Check container logs: `docker-compose logs -f`

### Permission Issues
- Code-server runs as user 1000:1000
- Ensure proper ownership: `sudo chown -R 1000:1000 code-server/`

### SSL/HTTPS Issues
- Caddy automatically handles Let's Encrypt certificates
- For custom domains, ensure DNS points to your server
- Local development uses HTTP on specified ports

## Architecture

- **LinuxServer Code-Server**: Runs on port 8443 (internal)
- **Caddy Reverse Proxy**: Handles HTTP/HTTPS and authentication
- **Docker Network**: Internal bridge network for communication
- **Authentication**: Disabled in code-server, handled by Caddy Basic Auth
