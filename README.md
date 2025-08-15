# Inception - Optimized Docker LAMP Stack

An optimized Docker setup for a complete LAMP stack with Nginx, WordPress, and MariaDB.

## 🚀 Optimizations Implemented

### Docker Build Optimizations
- **Layer Caching**: Combined RUN commands to reduce Docker layers
- **Build Context**: Added `.dockerignore` files to reduce build context size
- **Package Management**: Proper apt cache cleanup to reduce image sizes
- **Health Checks**: Built-in container health monitoring

### Performance Enhancements

#### Nginx
- **HTTP/2 Support**: Enabled for better performance
- **Gzip Compression**: Reduces bandwidth usage
- **SSL Optimization**: Modern cipher suites and session caching
- **Security Headers**: X-Frame-Options, X-Content-Type-Options, X-XSS-Protection
- **Static File Caching**: Optimized caching for assets

#### PHP-FPM
- **Process Management**: Optimized for better resource utilization
- **Buffer Optimization**: Increased FastCGI buffers for better performance
- **Resource Limits**: Proper memory and process limits

#### MariaDB
- **Buffer Pool**: Optimized InnoDB buffer pool size
- **Query Cache**: Enhanced query caching configuration
- **Connection Management**: Optimized connection settings
- **Performance Schema**: Tuned for better performance

### Security Improvements
- **SSL Configuration**: Strong cipher suites and protocols
- **File Permissions**: Proper security permissions on sensitive files
- **Error Handling**: Robust error handling in setup scripts

### Resource Management
- **Memory Limits**: Defined memory limits for all containers
- **Dependencies**: Proper service dependency management with health checks
- **Restart Policies**: Automatic container restart on failure

## 📁 Project Structure

```
inception/
├── Makefile                    # Enhanced build commands
├── srcs/
│   ├── docker-compose.yml     # Optimized service configuration
│   ├── .env                   # Environment variables
│   └── requirements/
│       ├── nginx/
│       │   ├── Dockerfile     # Optimized Nginx container
│       │   ├── conf/nginx.conf # Performance-tuned configuration
│       │   └── tools/nginx_start.sh # Enhanced startup script
│       ├── wordpress/
│       │   ├── Dockerfile     # Optimized WordPress container
│       │   ├── conf/www.conf  # Tuned PHP-FPM configuration
│       │   └── tools/create_wordpress.sh # Robust setup script
│       └── mariadb/
│           ├── Dockerfile     # Optimized database container
│           ├── conf/50-server.cnf # Performance-tuned DB config
│           └── tools/initial_db.sql # Database initialization
└── .dockerignore              # Optimized build context
```

## 🛠️ Usage

### Basic Commands
```bash
# Start all services (setup + build + run)
make all

# Stop services
make down

# View logs
make logs

# Check status
make status

# Full rebuild
make re

# Help
make help
```

### Advanced Commands
```bash
# Create directories only
make setup

# Start stopped containers
make start

# Stop without removing
make stop

# Rebuild without cache
make rebuild

# Full cleanup (including data)
make fclean
```

## 📊 Performance Improvements

### Build Time Optimizations
- **Reduced layers**: Combined RUN commands reduce build time
- **Smaller context**: `.dockerignore` files exclude unnecessary files
- **Package cleanup**: Reduces final image sizes

### Runtime Performance
- **Nginx**: HTTP/2, gzip compression, optimized SSL
- **PHP-FPM**: Better process management (up to 50 children vs 25)
- **MariaDB**: Increased buffer pools and optimized settings

### Memory Usage
- **Nginx**: 512MB limit (256MB reserved)
- **WordPress**: 1GB limit (512MB reserved)  
- **MariaDB**: 1GB limit (512MB reserved)

## 🔒 Security Features
- **Modern SSL**: TLS 1.2/1.3 with strong cipher suites
- **Security Headers**: Protection against common attacks
- **Proper Permissions**: Secure file permissions on certificates
- **Error Handling**: Robust error handling prevents information leakage

## 🏥 Health Monitoring
All containers include health checks:
- **Nginx**: HTTP endpoint monitoring
- **WordPress**: PHP-FPM process monitoring
- **MariaDB**: Database ping monitoring

## 📝 Environment Configuration
Configure via `srcs/.env`:
```env
MYSQL_ROOT_PASSWORD=your_root_password
MYSQL_DATABASE=wordpress
MYSQL_USER=your_user
MYSQL_PASSWORD=your_password
MYSQL_HOSTNAME=mariadb
DOMAIN_NAME=your_domain.42.fr
```

## 🔧 Customization
All configurations can be customized by modifying the respective config files:
- Nginx: `srcs/requirements/nginx/conf/nginx.conf`
- PHP-FPM: `srcs/requirements/wordpress/conf/www.conf`
- MariaDB: `srcs/requirements/mariadb/conf/50-server.cnf`

## 📈 Monitoring
Use the following commands to monitor your setup:
```bash
# Check container health
docker ps
make status

# View real-time logs
make logs

# Check resource usage
docker stats
```

This optimized setup provides better performance, security, and maintainability compared to basic Docker configurations.