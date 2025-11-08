@echo off
chcp 65001 >nul
title 表白墙数据同步测试工具

echo.
echo =====================================
echo 表白墙数据同步测试工具
echo =====================================
echo.

:menu
echo 请选择测试项目:
echo 1. 启动前台和管理员后台服务
echo 2. 添加测试数据到前台
echo 3. 验证前台数据
echo 4. 验证后台数据同步
echo 5. 打开数据同步监控
echo 6. 创建带有图片和视频的测试表白
echo 7. 清空所有测试数据
echo 8. 完整同步测试流程
echo 9. 退出
echo.
set /p choice=请输入选项 (1-9): 

if "%choice%"=="1" goto start_services
if "%choice%"=="2" goto add_frontend_data
if "%choice%"=="3" goto verify_frontend
if "%choice%"=="4" goto verify_backend
if "%choice%"=="5" goto open_monitor
if "%choice%"=="6" goto add_media_test
if "%choice%"=="7" goto clear_data
if "%choice%"=="8" goto full_test
if "%choice%"=="9" goto exit

echo 无效选项，请重新选择。
goto menu

:start_services
echo.
echo 正在启动服务...
start "前台服务" cmd /k "cd /d D:\表白墙部署 && 启动用户前台.bat"
timeout /t 2 >nul
start "后台服务" cmd /k "cd /d D:\表白墙部署 && 启动管理员后台.bat"
timeout /t 2 >nul
start http://localhost:8000
start http://localhost:8001
echo 服务已启动，请等待几秒后打开浏览器页面。
pause
goto menu

:add_frontend_data
echo.
echo 正在打开前台页面，请手动添加测试数据...
start http://localhost:8000
echo 请在前台页面添加几条表白数据，然后按任意键继续验证...
pause
goto menu

:verify_frontend
echo.
echo 正在打开前台页面验证数据...
start http://localhost:8000
echo 请检查前台页面是否显示了你添加的表白数据。
pause
goto menu

:verify_backend
echo.
echo 正在打开管理员后台验证数据同步...
start http://localhost:8001
echo 请检查管理员后台是否显示了前台添加的表白数据。
pause
goto menu

:open_monitor
echo.
echo 正在创建数据同步监控页面...
(
echo ^<!DOCTYPE html^>
echo ^<html lang="zh-CN"^>
echo ^<head^>
echo     ^<meta charset="UTF-8"^>
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^>
echo     ^<title^>数据同步监控^</title^>
echo     ^<style^>
echo         body { font-family: 'Microsoft YaHei', sans-serif; margin: 20px; background-color: #f5f5f5; }
echo         .container { max-width: 1200px; margin: 0 auto; background-color: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
echo         h1 { color: #333; margin-bottom: 20px; }
echo         h2 { color: #555; margin-bottom: 15px; }
echo         .status { padding: 10px; margin-bottom: 15px; border-radius: 5px; }
echo         .status.success { background-color: #d4edda; color: #155724; }
echo         .status.warning { background-color: #fff3cd; color: #856404; }
echo         .status.error { background-color: #f8d7da; color: #721c24; }
echo         .data-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px; }
echo         .data-section { border: 1px solid #ddd; padding: 15px; border-radius: 5px; }
echo         table { width: 100%%; border-collapse: collapse; margin-top: 10px; }
echo         th, td { text-align: left; padding: 8px; border-bottom: 1px solid #ddd; }
echo         th { background-color: #f2f2f2; }
echo         button { background-color: #007bff; color: white; border: none; padding: 8px 12px; border-radius: 4px; cursor: pointer; margin-right: 10px; margin-bottom: 10px; }
echo         button:hover { background-color: #0069d9; }
echo         .last-updated { font-size: 14px; color: #666; margin-bottom: 20px; }
echo     ^</style^>
echo ^</head^>
echo ^<body^>
echo     ^<div class="container"^>
echo         ^<h1^>表白墙数据同步监控^</h1^>
echo         ^<div id="status" class="status"^>正在检测状态...^</div^>
echo         ^<div class="last-updated"^>最后更新时间: ^<span id="updateTime"^>^-^</span^>^</div^>
echo         
echo         ^<div class="data-grid"^>
echo             ^<div class="data-section"^>
echo                 ^<h2^>数据存储状态^</h2^>
echo                 ^<div id="storageStatus"^>正在检测...^</div^>
echo             ^</div^>
echo             ^<div class="data-section"^>
echo                 ^<h2^>操作^</h2^>
echo                 ^<button onclick="checkStorage()^">检查存储状态^</button^>
echo                 ^<button onclick="refreshData()^">刷新数据^</button^>
echo                 ^<button onclick="openFrontend()^">打开前台^</button^>
echo                 ^<button onclick="openBackend()^">打开后台^</button^>
echo             ^</div^>
echo         ^</div^>
echo         
echo         ^<div class="data-section"^>
echo             ^<h2^>表白数据预览^</h2^>
echo             ^<div id="dataPreview"^>正在加载...^</div^>
echo         ^</div^>
echo     ^</div^>
echo 
echo     ^<script^>
echo         function updateStatus(message, type = 'success') {
echo             const statusEl = document.getElementById('status');
echo             statusEl.textContent = message;
echo             statusEl.className = 'status ' + type;
echo             document.getElementById('updateTime').textContent = new Date().toLocaleString();
echo         }
echo         
echo         function checkStorage() {
echo             const keys = ['global_confessions', 'confessions', 'frontend_confessions', 'user_confessions', 'admin_confessions'];
echo             let html = '^<table^>^<tr^>^<th^>存储键^</th^>^<th^>数据条数^</th^>^<th^>状态^</th^>^</tr^>';
echo             
echo             for (const key of keys) {
echo                 const data = localStorage.getItem(key);
echo                 let count = 0;
echo                 let status = '无数据';
echo                 
echo                 if (data) {
echo                     try {
echo                         const parsed = JSON.parse(data);
echo                         count = Array.isArray(parsed) ? parsed.length : 0;
echo                         status = count ^> 0 ? '有效数据' : '空数据';
echo                     } catch (e) {
echo                         status = '数据格式错误';
echo                     }
echo                 }
echo                 
echo                 html += `^<tr^>^<td^>${key}^</td^>^<td^>${count}^</td^>^<td^>${status}^</td^>^</tr^>`;
echo             }
echo             
echo             html += '^</table^>';
echo             document.getElementById('storageStatus').innerHTML = html;
echo             
echo             // 检查最新更新时间
echo             const lastUpdated = localStorage.getItem('confessions_last_updated');
echo             if (lastUpdated) {
echo                 updateStatus(`存储状态检查完成，最后更新于 ${new Date(parseInt(lastUpdated)).toLocaleString()}`, 'success');
echo             } else {
echo                 updateStatus('存储状态检查完成，但未找到更新时间记录', 'warning');
echo             }
echo         }
echo         
echo         function refreshData() {
echo             let data = null;
echo             const keys = ['global_confessions', 'confessions', 'frontend_confessions', 'user_confessions'];
echo             
echo             for (const key of keys) {
echo                 const rawData = localStorage.getItem(key);
echo                 if (rawData) {
echo                     try {
echo                         const parsed = JSON.parse(rawData);
echo                         if (Array.isArray(parsed) ^&^& parsed.length ^> 0) {
echo                             data = parsed;
echo                             break;
echo                         }
echo                     } catch (e) {
echo                         console.error(`解析 ${key} 失败:`, e);
echo                     }
echo                 }
echo             }
echo             
echo             if (data ^&^& data.length ^> 0) {
echo                 let html = '^<table^>^<tr^>^<th^>ID^</th^>^<th^>接收人^</th^>^<th^>发送人^</th^>^<th^>类型^</th^>^<th^>内容^</th^>^<th^>媒体数^</th^>^<th^>时间^</th^>^</tr^>';
echo                 
echo                 data.slice(0, 10).forEach(item =^> {
echo                     html += `^<tr^>`;
echo                     html += `^<td^>${item.id}^</td^>`;
echo                     html += `^<td^>${item.to}^</td^>`;
echo                     html += `^<td^>${item.from}^</td^>`;
echo                     html += `^<td^>${item.type}^</td^>`;
echo                     html += `^<td^>${item.content.substring(0, 50)}...^</td^>`;
echo                     html += `^<td^>${item.media ? item.media.length : 0}^</td^>`;
echo                     html += `^<td^>${item.timestamp}^</td^>`;
echo                     html += `^</tr^>`;
echo                 });
echo                 
echo                 html += '^</table^>';
echo                 
echo                 if (data.length ^> 10) {
echo                     html += `^<p^>显示前10条，共${data.length}条数据^</p^>`;
echo                 }
echo                 
echo                 document.getElementById('dataPreview').innerHTML = html;
echo                 updateStatus(`数据加载成功，共找到 ${data.length} 条表白`, 'success');
echo             } else {
echo                 document.getElementById('dataPreview').innerHTML = '^p^>未找到有效的表白数据^</p^>';
echo                 updateStatus('未找到有效的表白数据', 'warning');
echo             }
echo         }
echo         
echo         function openFrontend() {
echo             window.open('http://localhost:8000', '_blank');
echo         }
echo         
echo         function openBackend() {
echo             window.open('http://localhost:8001', '_blank');
echo         }
echo         
echo         // 设置定时刷新
echo         setInterval(() =^> {
echo             checkStorage();
echo             refreshData();
echo         }, 5000);
echo         
echo         // 初始加载
echo         window.onload = () =^> {
echo             updateStatus('数据同步监控已启动');
echo             checkStorage();
echo             refreshData();
echo         };
echo     ^</script^>
echo ^</body^>
echo ^</html^>
) > "D:\表白墙部署\数据同步监控.html"

echo 数据同步监控页面已创建: D:\表白墙部署\数据同步监控.html
start "" "D:\表白墙部署\数据同步监控.html"
echo 请在打开的监控页面中查看数据同步状态。
pause
goto menu

:add_media_test
echo.
echo 正在创建带有图片和视频的测试表白页面...
(
echo ^<!DOCTYPE html^>
echo ^<html lang="zh-CN"^>
echo ^<head^>
echo     ^<meta charset="UTF-8"^>
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^>
echo     ^<title^>添加媒体测试表白^</title^>
echo     ^<style^>
echo         body { font-family: 'Microsoft YaHei', sans-serif; margin: 20px; background-color: #f5f5f5; }
echo         .container { max-width: 800px; margin: 0 auto; background-color: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
echo         .form-group { margin-bottom: 15px; }
echo         label { display: block; margin-bottom: 5px; font-weight: bold; }
echo         input, select, textarea { width: 100%%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; }
echo         button { background-color: #007bff; color: white; border: none; padding: 10px 15px; border-radius: 4px; cursor: pointer; }
echo         button:hover { background-color: #0069d9; }
echo         .media-preview { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 10px; }
echo         .media-item { width: 150px; border: 1px solid #ddd; border-radius: 4px; padding: 5px; }
echo         .media-item img, .media-item video { width: 100%%; height: 100px; object-fit: cover; }
echo         .result { margin-top: 20px; padding: 10px; border-radius: 4px; }
echo         .success { background-color: #d4edda; color: #155724; }
echo         .error { background-color: #f8d7da; color: #721c24; }
echo     ^</style^>
echo ^</head^>
echo ^<body^>
echo     ^<div class="container"^>
echo         ^<h1^>添加媒体测试表白^</h1^>
echo         ^<form id="testForm"^>
echo             ^<div class="form-group"^>
echo                 ^<label for="to"^>接收人:^</label^>
echo                 ^<input type="text" id="to" value="小明" required^>
echo             ^</div^>
echo             ^<div class="form-group"^>
echo                 ^<label for="from"^>发送人:^</label^>
echo                 ^<input type="text" id="from" value="小红"^>
echo             ^</div^>
echo             ^<div class="form-group"^>
echo                 ^<label for="content"^>表白内容:^</label^>
echo                 ^<textarea id="content" rows="4" required^>这是一个带有图片和视频的测试表白，用于验证媒体文件上传和显示功能。^</textarea^>
echo             ^</div^>
echo             ^<div class="form-group"^>
echo                 ^<label for="type"^>表白类型:^</label^>
echo                 ^<select id="type"^>
echo                     ^<option value="love"^>💘 爱情表白^</option^>
echo                     ^<option value="friendship"^>🤝 友情表白^</option^>
echo                     ^<option value="admiration"^>🌟 欣赏表白^</option^>
echo                     ^<option value="thanks"^>🙏 感谢表白^</option^>
echo                 ^</select^>
echo             ^</div^>
echo             ^<div class="form-group"^>
echo                 ^<button type="button" id="addSampleImage"^>添加示例图片^</button^>
echo                 ^<button type="button" id="addSampleVideo"^>添加示例视频^</button^>
echo                 ^<button type="button" id="clearMedia"^>清除媒体^</button^>
echo             ^</div^>
echo             ^<div class="form-group"^>
echo                 ^<div id="mediaPreview" class="media-preview"^>^</div^>
echo             ^</div^>
echo             ^<div class="form-group"^>
echo                 ^<button type="submit"^>提交测试表白^</button^>
echo                 ^<button type="button" id="openFrontend"^>打开前台验证^</button^>
echo                 ^<button type="button" id="openBackend"^>打开后台验证^</button^>
echo             ^</div^>
echo         ^</form^>
echo         ^<div id="result"^>^</div^>
echo     ^</div^>
echo 
echo     ^<script^>
echo         const sampleImageUrl = 'https://picsum.photos/seed/test/600/400.jpg';
echo         const sampleVideoUrl = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
echo         
echo         let mediaFiles = [];
echo         
echo         // 添加示例图片
echo         document.getElementById('addSampleImage').addEventListener('click', async () =^> {
echo             try {
echo                 const response = await fetch(sampleImageUrl);
echo                 const blob = await response.blob();
echo                 const file = new File([blob], 'test-image.jpg', { type: 'image/jpeg' });
echo                 
echo                 const dataUrl = await fileToDataURL(file);
echo                 mediaFiles.push({
echo                     name: file.name,
echo                     type: file.type,
echo                     size: file.size,
echo                     data: dataUrl
echo                 });
echo                 
echo                 updateMediaPreview();
echo             } catch (error) {
echo                 console.error('加载示例图片失败:', error);
echo                 showResult('加载示例图片失败', 'error');
echo             }
echo         });
echo         
echo         // 添加示例视频
echo         document.getElementById('addSampleVideo').addEventListener('click', async () =^> {
echo             try {
echo                 const response = await fetch(sampleVideoUrl);
echo                 const blob = await response.blob();
echo                 const file = new File([blob], 'test-video.mp4', { type: 'video/mp4' });
echo                 
echo                 const dataUrl = await fileToDataURL(file);
echo                 mediaFiles.push({
echo                     name: file.name,
echo                     type: file.type,
echo                     size: file.size,
echo                     data: dataUrl
echo                 });
echo                 
echo                 updateMediaPreview();
echo             } catch (error) {
echo                 console.error('加载示例视频失败:', error);
echo                 showResult('加载示例视频失败', 'error');
echo             }
echo         });
echo         
echo         // 清除媒体
echo         document.getElementById('clearMedia').addEventListener('click', () =^> {
echo             mediaFiles = [];
echo             updateMediaPreview();
echo         });
echo         
echo         // 更新媒体预览
echo         function updateMediaPreview() {
echo             const preview = document.getElementById('mediaPreview');
echo             preview.innerHTML = '';
echo             
echo             mediaFiles.forEach((file, index) =^> {
echo                 const item = document.createElement('div');
echo                 item.className = 'media-item';
echo                 
echo                 if (file.type.startsWith('image/')) {
echo                     item.innerHTML = `^<img src="${file.data}" alt="${file.name}"^>`;
echo                 } else if (file.type.startsWith('video/')) {
echo                     item.innerHTML = `^<video src="${file.data}" controls^></video^>`;
echo                 }
echo                 
echo                 preview.appendChild(item);
echo             });
echo             
echo             showResult(`已添加 ${mediaFiles.length} 个媒体文件`, 'success');
echo         }
echo         
echo         // 文件转DataURL
echo         function fileToDataURL(file) {
echo             return new Promise((resolve, reject) =^> {
echo                 const reader = new FileReader();
echo                 reader.onload = () =^> resolve(reader.result);
echo                 reader.onerror = reject;
echo                 reader.readAsDataURL(file);
echo             });
echo         }
echo         
echo         // 表单提交
echo         document.getElementById('testForm').addEventListener('submit', (e) =^> {
echo             e.preventDefault();
echo             
echo             const confession = {
echo                 id: Date.now() + Math.random(),
echo                 to: document.getElementById('to').value,
echo                 from: document.getElementById('from').value,
echo                 content: document.getElementById('content').value,
echo                 type: document.getElementById('type').value,
echo                 timestamp: new Date().toLocaleString('zh-CN'),
echo                 likes: 0,
echo                 media: mediaFiles
echo             };
echo             
echo             // 保存到所有可能的位置
echo             const dataStr = JSON.stringify([confession]);
echo             localStorage.setItem('confessions', dataStr);
echo             localStorage.setItem('global_confessions', dataStr);
echo             localStorage.setItem('frontend_confessions', dataStr);
echo             localStorage.setItem('user_confessions', dataStr);
echo             localStorage.setItem('admin_confessions', dataStr);
echo             
echo             showResult('测试表白已添加，请在前台和后台验证', 'success');
echo         });
echo         
echo         // 打开前台
echo         document.getElementById('openFrontend').addEventListener('click', () =^> {
echo             window.open('http://localhost:8000', '_blank');
echo         });
echo         
echo         // 打开后台
echo         document.getElementById('openBackend').addEventListener('click', () =^> {
echo             window.open('http://localhost:8001', '_blank');
echo         });
echo         
echo         // 显示结果
echo         function showResult(message, type) {
echo             const resultEl = document.getElementById('result');
echo             resultEl.textContent = message;
echo             resultEl.className = 'result ' + type;
echo         }
echo     ^</script^>
echo ^</body^>
echo ^</html^>
) > "D:\表白墙部署\媒体测试表白.html"

echo 媒体测试表白页面已创建: D:\表白墙部署\媒体测试表白.html
start "" "D:\表白墙部署\媒体测试表白.html"
echo 请使用测试页面添加带有图片和视频的表白。
pause
goto menu

:clear_data
echo.
echo 确定要清空所有测试数据吗？(y/n)
set /p confirm=请输入选择: 
if /i not "%confirm%"=="y" goto menu

echo 正在清空所有表白数据...
for /f "delims=" %%i in ('echo global_confessions confessions frontend_confessions user_confessions admin_confessions') do (
    powershell -Command "[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; [PSCustomObject]@{key='%%i'} | ForEach-Object { [Console]::WriteLine('清除: ' + $_.key) }"
    powershell -Command "[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; Get-Item -Path 'env:LOCALAPPDATA' | ForEach-Object { $path = Join-Path -Path $_.Value -ChildPath '\Microsoft\Edge\User Data\Default\Local Storage\leveldb'; if (Test-Path $path) { Write-Host '清除 localStorage 中数据' } }"
)

echo 注意：此脚本只能清除浏览器中通过JavaScript设置的localStorage数据。
echo 对于完整的清除，请打开浏览器开发者工具(F12)，在控制台中执行以下命令:
echo.
echo localStorage.removeItem('global_confessions');
echo localStorage.removeItem('confessions');
echo localStorage.removeItem('frontend_confessions');
echo localStorage.removeItem('user_confessions');
echo localStorage.removeItem('admin_confessions');
echo localStorage.removeItem('confessions_last_updated');
echo.
echo 已创建清除命令，请在浏览器控制台中执行这些命令。
pause
goto menu

:full_test
echo.
echo 执行完整同步测试流程...
echo.
echo 1. 启动服务...
start "前台服务" cmd /k "cd /d D:\表白墙部署 && 启动用户前台.bat"
timeout /t 2 >nul
start "后台服务" cmd /k "cd /d D:\表白墙部署 && 启动管理员后台.bat"
timeout /t 2 >nul

echo.
echo 2. 等待服务启动...
timeout /t 5 >nul

echo.
echo 3. 打开测试页面...
start "" "D:\表白墙部署\媒体测试表白.html"
timeout /t 2 >nul

echo.
echo 4. 打开数据监控页面...
start "" "D:\表白墙部署\数据同步监控.html"

echo.
echo 完整测试流程已启动，请按照以下步骤操作:
echo.
echo 步骤1: 在"媒体测试表白"页面中添加一个带图片和视频的表白
echo 步骤2: 在"数据同步监控"页面中查看数据存储状态
echo 步骤3: 打开前台页面(http://localhost:8000)验证数据显示
echo 步骤4: 打开管理员后台页面(http://localhost:8001)验证数据同步
echo.
pause
goto menu

:exit
exit