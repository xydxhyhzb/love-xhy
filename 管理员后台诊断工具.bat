@echo off
chcp 65001 >nul
title 表白墙管理员后台诊断工具
color 0B

echo.
echo ========================================
echo        表白墙管理员后台诊断工具
echo ========================================
echo.

:menu
echo 请选择诊断项目:
echo.
echo 1. 检查管理员后台文件
echo 2. 启动管理员后台服务
echo 3. 修复管理员后台文件
echo 4. 重置管理员密码
echo 5. 清除管理员后台数据
echo 6. 一键修复所有问题
echo 7. 退出
echo.
set /p choice=请输入选项 (1-7): 

if "%choice%"=="1" goto check_files
if "%choice%"=="2" goto start_service
if "%choice%"=="3" goto fix_files
if "%choice%"=="4" goto reset_password
if "%choice%"=="5" goto clear_data
if "%choice%"=="6" goto fix_all
if "%choice%"=="7" goto exit

echo 无效选项，请重新选择。
goto menu

:check_files
echo.
echo ========================================
echo           检查管理员后台文件
echo ========================================
echo.

echo [信息] 检查管理员后台目录结构...
if not exist "D:\表白墙部署\管理员后台" (
    echo [错误] 管理员后台目录不存在
    goto create_directory
) else (
    echo [成功] 管理员后台目录存在
)

cd /d "D:\表白墙部署\管理员后台"

echo.
echo [信息] 检查必要文件...
if exist "index.html" (
    echo [成功] index.html 文件存在
) else (
    echo [错误] index.html 文件不存在
)

if exist "server.js" (
    echo [成功] server.js 文件存在
) else (
    echo [错误] server.js 文件不存在
)

if exist "network_server.js" (
    echo [成功] network_server.js 文件存在
) else (
    echo [错误] network_server.js 文件不存在
)

if exist "使用说明.txt" (
    echo [成功] 使用说明.txt 文件存在
) else (
    echo [警告] 使用说明.txt 文件不存在
)

echo.
pause
goto menu

:create_directory
echo [信息] 正在创建管理员后台目录...
mkdir "D:\表白墙部署\管理员后台" 2>nul
if %errorlevel% equ 0 (
    echo [成功] 管理员后台目录创建成功
) else (
    echo [错误] 管理员后台目录创建失败
    pause
    goto menu
)
goto check_files

:start_service
echo.
echo ========================================
echo           启动管理员后台服务
echo ========================================
echo.

echo [信息] 检查Node.js环境...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未检测到Node.js，请先安装Node.js
    echo [下载] https://nodejs.org/
    pause
    goto menu
) else (
    echo [成功] Node.js已安装
    for /f "tokens=*" %%i in ('node --version') do echo [信息] 版本: %%i
)

echo.
echo [信息] 检查端口8001是否被占用...
netstat -ano | findstr :8001 >nul
if %errorlevel% equ 0 (
    echo [警告] 端口8001已被占用，尝试使用8081端口...
    set ALT_PORT=8081
) else (
    echo [信息] 端口8001可用
    set ALT_PORT=8001
)

echo.
echo [信息] 启动管理员后台服务...
cd /d "D:\表白墙部署\管理员后台"

if %ALT_PORT%==8001 (
    if exist "server.js" (
        echo [信息] 使用本地版服务器...
        start "表白墙管理员后台" cmd /k "node server.js"
        timeout /t 2 /nobreak >nul
        start http://localhost:8001
    ) else (
        echo [错误] server.js 文件不存在，请先修复文件
        pause
        goto menu
    )
) else (
    if exist "network_server.js" (
        echo [信息] 使用网络版服务器...
        start "表白墙管理员后台" cmd /k "node network_server.js"
        timeout /t 2 /nobreak >nul
        start http://localhost:8081
    ) else (
        echo [错误] network_server.js 文件不存在，请先修复文件
        pause
        goto menu
    )
)

echo [成功] 管理员后台服务已启动
echo.
echo [信息] 默认登录账号: admin
echo [信息] 默认登录密码: 123456
echo.
pause
goto menu

:fix_files
echo.
echo ========================================
echo           修复管理员后台文件
echo ========================================
echo.

echo [信息] 正在创建必要的目录...
if not exist "D:\表白墙部署\管理员后台" (
    mkdir "D:\表白墙部署\管理员后台"
)

cd /d "D:\表白墙部署\管理员后台"

echo.
echo [信息] [1/3] 修复index.html文件...
if not exist "index.html" (
    echo [警告] index.html文件不存在，无法自动修复
    echo [提示] 请从原始部署文件中复制index.html
    pause
    goto menu
) else (
    echo [成功] index.html文件已存在
)

echo.
echo [信息] [2/3] 修复server.js文件...
(
echo const http = require('http'); > server.js
echo const fs = require('fs'); >> server.js
echo const path = require('path'); >> server.js
echo. >> server.js
echo const PORT = 8001; >> server.js
echo const SERVER_TITLE = '表白墙管理员后台'; >> server.js
echo. >> server.js
echo const MIME_TYPES = { >> server.js
echo   '.html': 'text/html', >> server.js
echo   '.js': 'text/javascript', >> server.js
echo   '.css': 'text/css', >> server.js
echo   '.json': 'application/json', >> server.js
echo   '.png': 'image/png', >> server.js
echo   '.jpg': 'image/jpeg', >> server.js
echo   '.gif': 'image/gif', >> server.js
echo   '.svg': 'image/svg+xml', >> server.js
echo   '.wav': 'audio/wav', >> server.js
echo   '.mp4': 'video/mp4', >> server.js
echo   '.woff': 'application/font-woff', >> server.js
echo   '.ttf': 'application/font-ttf', >> server.js
echo   '.eot': 'application/vnd.ms-fontobject', >> server.js
echo   '.otf': 'application/font-otf', >> server.js
echo   '.wasm': 'application/wasm' >> server.js
echo }; >> server.js
echo. >> server.js
echo const server = http.createServer((req, res) =^> { >> server.js
echo   // 解析URL >> server.js
echo   let filePath = '.' + req.url; >> server.js
echo   if (filePath === './') { >> server.js
echo     filePath = './index.html'; >> server.js
echo   } >> server.js
echo. >> server.js
echo   // 获取文件扩展名 >> server.js
echo   const extname = String(path.extname(filePath)).toLowerCase(); >> server.js
echo   const mimeType = MIME_TYPES[extname] ^|^| 'application/octet-stream'; >> server.js
echo. >> server.js
echo   // 设置CORS头 >> server.js
echo   res.setHeader('Access-Control-Allow-Origin', '*'); >> server.js
echo   res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE'); >> server.js
echo   res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization'); >> server.js
echo. >> server.js
echo   // 读取文件 >> server.js
echo   fs.readFile(filePath, (error, content) =^> { >> server.js
echo     if (error) { >> server.js
echo       if (error.code === 'ENOENT') { >> server.js
echo         res.writeHead(404, { 'Content-Type': 'text/html' }); >> server.js
echo         res.end('^<h1^>404 Not Found^</h1^>', 'utf-8'); >> server.js
echo       } else { >> server.js
echo         res.writeHead(500); >> server.js
echo         res.end('Server Error: ' + error.code, 'utf-8'); >> server.js
echo       } >> server.js
echo     } else { >> server.js
echo       res.writeHead(200, { 'Content-Type': mimeType }); >> server.js
echo       res.end(content, 'utf-8'); >> server.js
echo     } >> server.js
echo   }); >> server.js
echo }); >> server.js
echo. >> server.js
echo server.listen(PORT, () =^> { >> server.js
echo   console.log(''); >> server.js
echo   '========================================'); >> server.js
echo   console.log('  ' + SERVER_TITLE + ' 服务器已启动'); >> server.js
echo   '========================================'); >> server.js
echo   console.log(''); >> server.js
echo   console.log('访问地址: http://localhost:' + PORT); >> server.js
echo   console.log(''); >> server.js
echo   console.log('默认登录账号: admin'); >> server.js
echo   console.log('默认登录密码: 123456'); >> server.js
echo   console.log(''); >> server.js
echo   console.log('按 Ctrl+C 停止服务器'); >> server.js
echo   console.log(''); >> server.js
echo   '========================================'); >> server.js
echo }); >> server.js
)

echo.
echo [信息] [3/3] 修复network_server.js文件...
(
echo const http = require('http'); > network_server.js
echo const fs = require('fs'); >> network_server.js
echo const path = require('path'); >> network_server.js
echo const os = require('os'); >> network_server.js
echo. >> network_server.js
echo const PORT = 8001; >> network_server.js
echo const SERVER_TITLE = '表白墙管理员后台'; >> network_server.js
echo. >> network_server.js
echo // 获取本机所有网络接口 >> network_server.js
echo const networkInterfaces = os.networkInterfaces(); >> network_server.js
echo const addresses = []; >> network_server.js
echo for (const name of Object.keys(networkInterfaces)) { >> network_server.js
echo   for (const iface of networkInterfaces[name]) { >> network_server.js
echo     if (iface.family === 'IPv4' ^&^& !iface.internal) { >> network_server.js
echo       addresses.push(iface.address); >> network_server.js
echo     } >> network_server.js
echo   } >> network_server.js
echo } >> network_server.js
echo. >> network_server.js
echo const MIME_TYPES = { >> network_server.js
echo   '.html': 'text/html', >> network_server.js
echo   '.js': 'text/javascript', >> network_server.js
echo   '.css': 'text/css', >> network_server.js
echo   '.json': 'application/json', >> network_server.js
echo   '.png': 'image/png', >> network_server.js
echo   '.jpg': 'image/jpeg', >> network_server.js
echo   '.gif': 'image/gif', >> network_server.js
echo   '.svg': 'image/svg+xml', >> network_server.js
echo   '.wav': 'audio/wav', >> network_server.js
echo   '.mp4': 'video/mp4', >> network_server.js
echo   '.woff': 'application/font-woff', >> network_server.js
echo   '.ttf': 'application/font-ttf', >> network_server.js
echo   '.eot': 'application/vnd.ms-fontobject', >> network_server.js
echo   '.otf': 'application/font-otf', >> network_server.js
echo   '.wasm': 'application/wasm' >> network_server.js
echo }; >> network_server.js
echo. >> network_server.js
echo const server = http.createServer((req, res) =^> { >> network_server.js
echo   // 解析URL >> network_server.js
echo   let filePath = '.' + req.url; >> network_server.js
echo   if (filePath === './') { >> network_server.js
echo     filePath = './index.html'; >> network_server.js
echo   } >> network_server.js
echo. >> network_server.js
echo   // 获取文件扩展名 >> network_server.js
echo   const extname = String(path.extname(filePath)).toLowerCase(); >> network_server.js
echo   const mimeType = MIME_TYPES[extname] ^|^| 'application/octet-stream'; >> network_server.js
echo. >> network_server.js
echo   // 设置CORS头 >> network_server.js
echo   res.setHeader('Access-Control-Allow-Origin', '*'); >> network_server.js
echo   res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS'); >> network_server.js
echo   res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization'); >> network_server.js
echo. >> network_server.js
echo   // 处理OPTIONS请求 >> network_server.js
echo   if (req.method === 'OPTIONS') { >> network_server.js
echo     res.writeHead(200); >> network_server.js
echo     res.end(); >> network_server.js
echo     return; >> network_server.js
echo   } >> network_server.js
echo. >> network_server.js
echo   // 读取文件 >> network_server.js
echo   fs.readFile(filePath, (error, content) =^> { >> network_server.js
echo     if (error) { >> network_server.js
echo       if (error.code === 'ENOENT') { >> network_server.js
echo         res.writeHead(404, { 'Content-Type': 'text/html' }); >> network_server.js
echo         res.end('^<h1^>404 Not Found^</h1^>', 'utf-8'); >> network_server.js
echo       } else { >> network_server.js
echo         res.writeHead(500); >> network_server.js
echo         res.end('Server Error: ' + error.code, 'utf-8'); >> network_server.js
echo       } >> network_server.js
echo     } else { >> network_server.js
echo       res.writeHead(200, { 'Content-Type': mimeType }); >> network_server.js
echo       res.end(content, 'utf-8'); >> network_server.js
echo     } >> network_server.js
echo   }); >> network_server.js
echo }); >> network_server.js
echo. >> network_server.js
echo // 绑定到所有网络接口(0.0.0.0)允许外部访问 >> network_server.js
echo server.listen(PORT, '0.0.0.0', () =^> { >> network_server.js
echo   console.log(''); >> network_server.js
echo   '========================================'); >> network_server.js
echo   console.log('  ' + SERVER_TITLE + ' 服务器已启动'); >> network_server.js
echo   '========================================'); >> network_server.js
echo   console.log(''); >> network_server.js
echo   console.log('本地访问地址: http://localhost:' + PORT); >> network_server.js
echo   console.log(''); >> network_server.js
echo   if (addresses.length ^> 0) { >> network_server.js
echo     console.log('局域网访问地址:'); >> network_server.js
echo     addresses.forEach(address =^> { >> network_server.js
echo       console.log('  - http://' + address + ':' + PORT); >> network_server.js
echo     }); >> network_server.js
echo     console.log(''); >> network_server.js
echo   } >> network_server.js
echo   console.log('默认登录账号: admin'); >> network_server.js
echo   console.log('默认登录密码: 123456'); >> network_server.js
echo   console.log(''); >> network_server.js
echo   console.log('按 Ctrl+C 停止服务器'); >> network_server.js
echo   console.log(''); >> network_server.js
echo   '========================================'); >> network_server.js
echo }); >> network_server.js
echo. >> network_server.js
echo // 错误处理 >> network_server.js
echo server.on('error', (err) =^> { >> network_server.js
echo   if (err.code === 'EADDRINUSE') { >> network_server.js
echo     console.error('端口 ' + PORT + ' 已被占用，请尝试其他端口'); >> network_server.js
echo     process.exit(1); >> network_server.js
echo   } else { >> network_server.js
echo     console.error('服务器错误:', err); >> network_server.js
echo     process.exit(1); >> network_server.js
echo   } >> network_server.js
echo }); >> network_server.js
)

echo.
echo [成功] 管理员后台文件修复完成
pause
goto menu

:reset_password
echo.
echo ========================================
echo           重置管理员密码
echo ========================================
echo.

echo [警告] 此操作将修改管理员登录密码
echo [注意] 当前默认账号: admin / 123456
echo.

set /p new_password=请输入新密码（留空保持默认）: 

if "%new_password%"=="" (
    echo [信息] 保持默认密码: 123456
    pause
    goto menu
) else (
    echo [信息] 正在创建密码重置脚本...
    
    :: 创建密码重置页面
    (
    echo ^<!DOCTYPE html^>
    echo ^<html lang="zh-CN"^>
    echo ^<head^>
    echo     ^<meta charset="UTF-8"^>
    echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^>
    echo     ^<title^>密码重置工具^</title^>
    echo     ^<style^>
    echo         body { font-family: 'Microsoft YaHei', sans-serif; margin: 20px; background-color: #f5f5f5; }
    echo         .container { max-width: 500px; margin: 0 auto; background-color: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
    echo         h1 { color: #667eea; text-align: center; margin-bottom: 20px; }
    echo         .form-group { margin-bottom: 15px; }
    echo         label { display: block; margin-bottom: 5px; font-weight: bold; }
    echo         input { width: 100%%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; }
    echo         button { background-color: #667eea; color: white; border: none; padding: 10px 15px; border-radius: 4px; cursor: pointer; width: 100%%; }
    echo         button:hover { background-color: #5a6fd8; }
    echo         .note { background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 4px; margin-bottom: 15px; }
    echo     ^</style^>
    echo ^</head^>
    echo ^<body^>
    echo     ^<div class="container"^>
    echo         ^<h1^>密码重置工具^</h1^>
    echo         ^<div class="note"^>
    echo             此工具用于修改管理员后台的登录密码。请记录新密码，修改后立即生效。
    echo         ^</div^>
    echo         ^<div class="form-group"^>
    echo             ^<label for="username"^>用户名:^</label^>
    echo             ^<input type="text" id="username" value="admin" readonly^>
    echo         ^</div^>
    echo         ^<div class="form-group"^>
    echo             ^<label for="password"^>新密码:^</label^>
    echo             ^<input type="text" id="password" value="%new_password%"^>
    echo         ^</div^>
    echo         ^<button onclick="updatePassword()"^>更新密码^</button^>
    echo         ^<div style="margin-top: 15px; font-size: 14px; color: #666;"^>
    echo             密码更新后，请使用新密码登录管理员后台。
    echo         ^</div^>
    echo     ^</div^>
    echo 
    echo     ^<script^>
    echo         function updatePassword() {
    echo             const username = document.getElementById('username').value;
    echo             const password = document.getElementById('password').value;
    echo             
    echo             // 在实际应用中，这里应该连接到服务器更新密码
    echo             // 由于使用静态文件，我们需要修改后台页面中的密码验证逻辑
    echo             
    echo             // 创建一个新的管理员后台页面，使用新密码
    echo             localStorage.setItem('admin_username', username);
    echo             localStorage.setItem('admin_password', password);
    echo             
    echo             alert('密码已更新为: ' + password + '\n\n请记住新密码，然后访问管理员后台页面。');
    echo         }
    echo     ^</script^>
    echo ^</body^>
    echo ^</html^>
    ) > "D:\表白墙部署\管理员后台\password_reset.html"
    
    start "" "D:\表白墙部署\管理员后台\password_reset.html"
    echo [成功] 密码重置页面已打开
    echo [信息] 新密码: %new_password%
    pause
    goto menu
)

:clear_data
echo.
echo ========================================
echo           清除管理员后台数据
echo ========================================
echo.

echo [警告] 此操作将清除所有表白数据和管理员登录信息
echo.
echo [提示] 如果只需要清除登录信息，请选择选项5重置密码
echo.
set /p confirm=确认清除所有数据？(输入 YES 确认): 

if not "%confirm%"=="YES" (
    echo [取消] 操作已取消
    pause
    goto menu
)

echo [信息] 正在创建数据清除脚本...

:: 创建数据清除页面
(
echo ^<!DOCTYPE html^>
echo ^<html lang="zh-CN"^>
echo ^<head^>
echo     ^<meta charset="UTF-8"^>
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^>
echo     ^<title^>数据清除工具^</title^>
echo     ^<style^>
echo         body { font-family: 'Microsoft YaHei', sans-serif; margin: 20px; background-color: #f5f5f5; }
echo         .container { max-width: 500px; margin: 0 auto; background-color: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
echo         h1 { color: #dc3545; text-align: center; margin-bottom: 20px; }
echo         .warning { background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 4px; margin-bottom: 20px; border: 1px solid #f5c6cb; }
echo         .form-group { margin-bottom: 15px; }
echo         label { display: block; margin-bottom: 5px; font-weight: bold; }
echo         button { background-color: #dc3545; color: white; border: none; padding: 10px 15px; border-radius: 4px; cursor: pointer; width: 100%%; }
echo         button:hover { background-color: #c82333; }
echo         .note { background-color: #d1ecf1; color: #0c5460; padding: 10px; border-radius: 4px; margin-top: 15px; border: 1px solid #bee5eb; }
echo     ^</style^>
echo ^</head^>
echo ^<body^>
echo     ^<div class="container"^>
echo         ^<h1^>数据清除工具^</h1^>
echo         ^<div class="warning"^>
echo             ^<strong^>警告: 此操作将永久删除所有表白数据！^</strong^>^<br^>
echo             这包括所有表白消息、上传的图片/视频以及管理员登录信息。^<br^>
echo             此操作不可撤销！
echo         ^</div^>
echo         ^<button onclick="clearAllData()"^>清除所有数据^</button^>
echo         ^<div class="note"^>
echo             清除后，系统将恢复到初始状态，默认管理员账号为 admin/123456。
echo         ^</div^>
echo     ^</div^>
echo 
echo     ^<script^>
echo         function clearAllData() {
echo             if (confirm('确定要清除所有数据吗？此操作不可撤销！')) {
echo                 // 清除所有表白数据
echo                 localStorage.removeItem('global_confessions');
echo                 localStorage.removeItem('confessions');
echo                 localStorage.removeItem('frontend_confessions');
echo                 localStorage.removeItem('user_confessions');
echo                 localStorage.removeItem('admin_confessions');
echo                 localStorage.removeItem('confessions_last_updated');
echo                 
echo                 // 清除管理员登录信息
echo                 localStorage.removeItem('adminLoggedIn');
echo                 localStorage.removeItem('loginTime');
echo                 
echo                 alert('所有数据已清除！系统已恢复到初始状态。');
echo             }
echo         }
echo     ^</script^>
echo ^</body^>
echo ^</html^>
) > "D:\表白墙部署\管理员后台\clear_data.html"

start "" "D:\表白墙部署\管理员后台\clear_data.html"
echo [成功] 数据清除页面已打开
echo [信息] 请在打开的页面中执行数据清除操作
pause
goto menu

:fix_all
echo.
echo ========================================
echo           一键修复所有问题
echo ========================================
echo.

echo [信息] 正在执行一键修复...
echo.

echo [1/4] 检查并创建目录...
if not exist "D:\表白墙部署\管理员后台" (
    mkdir "D:\表白墙部署\管理员后台"
    echo [成功] 管理员后台目录已创建
) else (
    echo [成功] 管理员后台目录已存在
)

cd /d "D:\表白墙部署\管理员后台"

echo.
echo [2/4] 修复服务器文件...
call :fix_files_silent

echo.
echo [3/4] 启动服务...
netstat -ano | findstr :8001 >nul 2>&1
if %errorlevel% equ 0 (
    echo [信息] 端口8001已被占用，使用8081端口
    start "表白墙管理员后台" cmd /k "node network_server.js"
    timeout /t 2 /nobreak >nul
    start http://localhost:8081
) else (
    echo [信息] 使用8001端口
    start "表白墙管理员后台" cmd /k "node server.js"
    timeout /t 2 /nobreak >nul
    start http://localhost:8001
)

echo.
echo [4/4] 显示访问信息...
echo [成功] 管理员后台已启动
echo.
echo [信息] 默认登录账号: admin
echo [信息] 默认登录密码: 123456
echo.
echo [提示] 如果无法访问，请检查防火墙设置
echo.
pause
goto menu

:fix_files_silent
:: 静默修复服务器文件
(
echo const http = require('http'); > server.js
echo const fs = require('fs'); >> server.js
echo const path = require('path'); >> server.js
echo. >> server.js
echo const PORT = 8001; >> server.js
echo const SERVER_TITLE = '表白墙管理员后台'; >> server.js
echo. >> server.js
echo const MIME_TYPES = { >> server.js
echo   '.html': 'text/html', >> server.js
echo   '.js': 'text/javascript', >> server.js
echo   '.css': 'text/css', >> server.js
echo   '.json': 'application/json', >> server.js
echo   '.png': 'image/png', >> server.js
echo   '.jpg': 'image/jpeg', >> server.js
echo   '.gif': 'image/gif', >> server.js
echo   '.svg': 'image/svg+xml', >> server.js
echo   '.wav': 'audio/wav', >> server.js
echo   '.mp4': 'video/mp4', >> server.js
echo   '.woff': 'application/font-woff', >> server.js
echo   '.ttf': 'application/font-ttf', >> server.js
echo   '.eot': 'application/vnd.ms-fontobject', >> server.js
echo   '.otf': 'application/font-otf', >> server.js
echo   '.wasm': 'application/wasm' >> server.js
echo }; >> server.js
echo. >> server.js
echo const server = http.createServer((req, res) =^> { >> server.js
echo   // 解析URL >> server.js
echo   let filePath = '.' + req.url; >> server.js
echo   if (filePath === './') { >> server.js
echo     filePath = './index.html'; >> server.js
echo   } >> server.js
echo. >> server.js
echo   // 获取文件扩展名 >> server.js
echo   const extname = String(path.extname(filePath)).toLowerCase(); >> server.js
echo   const mimeType = MIME_TYPES[extname] ^|^| 'application/octet-stream'; >> server.js
echo. >> server.js
echo   // 设置CORS头 >> server.js
echo   res.setHeader('Access-Control-Allow-Origin', '*'); >> server.js
echo   res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE'); >> server.js
echo   res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization'); >> server.js
echo. >> server.js
echo   // 读取文件 >> server.js
echo   fs.readFile(filePath, (error, content) =^> { >> server.js
echo     if (error) { >> server.js
echo       if (error.code === 'ENOENT') { >> server.js
echo         res.writeHead(404, { 'Content-Type': 'text/html' }); >> server.js
echo         res.end('^<h1^>404 Not Found^</h1^>', 'utf-8'); >> server.js
echo       } else { >> server.js
echo         res.writeHead(500); >> server.js
echo         res.end('Server Error: ' + error.code, 'utf-8'); >> server.js
echo       } >> server.js
echo     } else { >> server.js
echo       res.writeHead(200, { 'Content-Type': mimeType }); >> server.js
echo       res.end(content, 'utf-8'); >> server.js
echo     } >> server.js
echo   }); >> server.js
echo }); >> server.js
echo. >> server.js
echo server.listen(PORT, () =^> { >> server.js
echo   console.log(''); >> server.js
echo   '========================================'); >> server.js
echo   console.log('  ' + SERVER_TITLE + ' 服务器已启动'); >> server.js
echo   '========================================'); >> server.js
echo   console.log(''); >> server.js
echo   console.log('访问地址: http://localhost:' + PORT); >> server.js
echo   console.log(''); >> server.js
echo   console.log('默认登录账号: admin'); >> server.js
echo   console.log('默认登录密码: 123456'); >> server.js
echo   console.log(''); >> server.js
echo   console.log('按 Ctrl+C 停止服务器'); >> server.js
echo   console.log(''); >> server.js
echo   '========================================'); >> server.js
echo }); >> server.js
)

goto :eof

:exit
exit