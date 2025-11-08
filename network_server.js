const http = require('http');
const fs = require('fs');
const path = require('path');
const os = require('os');

const PORT = 8001;
const SERVER_TITLE = '表白墙管理员后台';

// 获取本机所有网络接口
const networkInterfaces = os.networkInterfaces();
const addresses = [];
for (const name of Object.keys(networkInterfaces)) {
  for (const iface of networkInterfaces[name]) {
    if (iface.family === 'IPv4' && !iface.internal) {
      addresses.push(iface.address);
    }
  }
}

const MIME_TYPES = {
  '.html': 'text/html',
  '.js': 'text/javascript',
  '.css': 'text/css',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.wav': 'audio/wav',
  '.mp4': 'video/mp4',
  '.woff': 'application/font-woff',
  '.ttf': 'application/font-ttf',
  '.eot': 'application/vnd.ms-fontobject',
  '.otf': 'application/font-otf',
  '.wasm': 'application/wasm'
};

const server = http.createServer((req, res) => {
  // 解析URL
  let filePath = '.' + req.url;
  if (filePath === './') {
    filePath = './index.html';
  }

  // 获取文件扩展名
  const extname = String(path.extname(filePath)).toLowerCase();
  const mimeType = MIME_TYPES[extname] || 'application/octet-stream';

  // 设置CORS头
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  // 处理OPTIONS请求
  if (req.method === 'OPTIONS') {
    res.writeHead(200);
    res.end();
    return;
  }

  // 读取文件
  fs.readFile(filePath, (error, content) => {
    if (error) {
      if (error.code === 'ENOENT') {
        res.writeHead(404, { 'Content-Type': 'text/html' });
        res.end('<h1>404 Not Found</h1>', 'utf-8');
      } else {
        res.writeHead(500);
        res.end('Server Error: ' + error.code, 'utf-8');
      }
    } else {
      res.writeHead(200, { 'Content-Type': mimeType });
      res.end(content, 'utf-8');
    }
  });
});

// 绑定到所有网络接口(0.0.0.0)允许外部访问
server.listen(PORT, '0.0.0.0', () => {
  console.log('');
  console.log('========================================');
  console.log('  ' + SERVER_TITLE + ' 服务器已启动');
  console.log('========================================');
  console.log('');
  console.log('本地访问地址: http://localhost:' + PORT);
  console.log('');
  if (addresses.length > 0) {
    console.log('局域网访问地址:');
    addresses.forEach(address => {
      console.log('  - http://' + address + ':' + PORT);
    });
    console.log('');
  }
  console.log('默认登录账号: admin');
  console.log('默认登录密码: 123456');
  console.log('');
  console.log('按 Ctrl+C 停止服务器');
  console.log('');
  console.log('========================================');
});

// 错误处理
server.on('error', (err) => {
  if (err.code === 'EADDRINUSE') {
    console.error('端口 ' + PORT + ' 已被占用，请尝试其他端口');
    process.exit(1);
  } else {
    console.error('服务器错误:', err);
    process.exit(1);
  }
});