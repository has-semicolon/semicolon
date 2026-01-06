# Deployment Guide - Lightsail

## Prerequisites

- AWS Lightsail instance running Ubuntu/Debian
- Python 3.13+
- Node.js 18+

## Step 1: Lightsail Firewall Configuration

You need to open the following ports in your Lightsail instance:

1. Go to your Lightsail instance page
2. Click on **Networking** tab
3. Under **Firewall**, add these rules:

| Application | Protocol | Port | Source                    |
| ----------- | -------- | ---- | ------------------------- |
| Custom      | TCP      | 3000 | Any IPv4/IPv6 (0.0.0.0/0) |
| Custom      | TCP      | 8000 | Any IPv4/IPv6 (0.0.0.0/0) |
| SSH         | TCP      | 22   | Any IPv4/IPv6 (0.0.0.0/0) |
| HTTP        | TCP      | 80   | Any IPv4/IPv6 (0.0.0.0/0) |
| HTTPS       | TCP      | 443  | Any IPv4/IPv6 (0.0.0.0/0) |

**Important:** Ports 3000 and 8000 are required for frontend and backend access!

## Step 2: Environment Configuration

### On Your Server

1. Create backend environment file:

```bash
cd ~/semicolon/backend
cp .env.example .env
nano .env
```

Update the following values:

```env
# Replace with a secure random string
SECRET_KEY=your-super-secret-key-here-change-this

# Add your server's public IP or domain
# Format: http://YOUR_IP:3000
BACKEND_CORS_ORIGINS=http://YOUR_SERVER_IP:3000,http://localhost:3000

DATABASE_URL=sqlite:///./semicolon.db
```

2. Create frontend environment file:

```bash
cd ~/semicolon/frontend
cp .env.example .env
nano .env
```

Update with your server's IP:

```env
# Replace YOUR_SERVER_IP with your actual Lightsail public IP
VITE_API_BASE_URL=http://YOUR_SERVER_IP:8000
```

## Step 3: Run the Application

```bash
cd ~/semicolon
chmod +x start.sh
./start.sh
```

## Step 4: Access from Your Laptop

Once the servers are running, access them from your laptop using:

- **Frontend**: `http://YOUR_SERVER_IP:3000`
- **Backend API**: `http://YOUR_SERVER_IP:8000`
- **API Docs**: `http://YOUR_SERVER_IP:8000/docs`

Replace `YOUR_SERVER_IP` with your Lightsail instance's public IP address.

## Finding Your Lightsail Public IP

On your Lightsail instance, run:

```bash
curl ifconfig.me
```

Or check the Lightsail console for the public IP address.

## Troubleshooting

### Cannot Access from Laptop

1. **Check firewall rules:**

   - Ensure ports 3000 and 8000 are open in Lightsail firewall
   - Verify with: `sudo ufw status` (if UFW is enabled)

2. **Check if servers are running:**

   ```bash
   # Check if backend is running
   curl http://localhost:8000/docs

   # Check if frontend is running
   curl http://localhost:3000
   ```

3. **Verify servers are listening on 0.0.0.0:**

   ```bash
   sudo netstat -tulpn | grep -E ':(3000|8000)'
   ```

   Should show:

   ```
   tcp   0   0.0.0.0:8000   0.0.0.0:*   LISTEN
   tcp   0   0.0.0.0:3000   0.0.0.0:*   LISTEN
   ```

4. **Check CORS settings:**

   - Make sure `BACKEND_CORS_ORIGINS` includes your laptop's access URL
   - Check backend logs: `cat ~/semicolon/backend/backend.log`

5. **Test connectivity:**
   From your laptop:
   ```bash
   # Test if port is reachable
   telnet YOUR_SERVER_IP 8000
   telnet YOUR_SERVER_IP 3000
   ```

### Frontend Cannot Connect to Backend

If frontend loads but shows API errors:

1. Check browser console for CORS errors
2. Verify `VITE_API_BASE_URL` in frontend `.env` points to your server IP
3. Rebuild frontend after changing environment variables:
   ```bash
   cd ~/semicolon/frontend
   npm run build
   ```
4. Restart servers: `./stop.sh && ./start.sh`

## Production Setup (Optional)

For production, consider:

1. **Use a reverse proxy (Nginx):**

   - Serve frontend on port 80
   - Proxy API requests to port 8000
   - Add SSL certificate

2. **Use a process manager:**

   - systemd services instead of background scripts
   - Auto-restart on failure

3. **Use PostgreSQL:**

   - Better performance and reliability than SQLite

4. **Enable HTTPS:**
   - Use Let's Encrypt for free SSL certificates
   - Redirect HTTP to HTTPS

See [NGINX_SETUP.md](./NGINX_SETUP.md) for detailed production setup guide (coming soon).

## Security Notes

- Change `SECRET_KEY` in production to a strong random value
- Use environment-specific `.env` files (don't commit them to git)
- Consider using a VPN or IP whitelist for admin access
- Enable HTTPS in production
- Keep your system and packages updated

## Stopping Servers

```bash
cd ~/semicolon
./stop.sh
```

## Monitoring

View logs:

```bash
# Backend logs
tail -f ~/semicolon/backend/backend.log

# Frontend logs
tail -f ~/semicolon/frontend/frontend.log
```
