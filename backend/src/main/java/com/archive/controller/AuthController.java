package com.archive.controller;

import com.archive.common.Result;
import com.archive.dto.LoginRequest;
import com.archive.dto.LoginResponse;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/auth")
public class AuthController {

    @PostMapping("/login")
    public Result<LoginResponse> login(@RequestBody LoginRequest request) {
        // 简单验证(后续需要连接数据库)
        if ("admin".equals(request.getUsername()) && "admin123".equals(request.getPassword())) {
            LoginResponse response = new LoginResponse();

            // 生成token
            String token = UUID.randomUUID().toString().replace("-", "");
            response.setToken(token);

            // 设置用户信息
            LoginResponse.UserInfo userInfo = new LoginResponse.UserInfo();
            userInfo.setId(1L);
            userInfo.setUsername("admin");
            userInfo.setRealName("系统管理员");
            userInfo.setEmail("admin@archive.com");
            userInfo.setPhone("13800138000");
            userInfo.setDepartment("信息技术部");
            userInfo.setPosition("系统管理员");
            response.setUserInfo(userInfo);

            return Result.success(response);
        }

        return Result.error(401, "用户名或密码错误");
    }

    @GetMapping("/userinfo")
    public Result<LoginResponse.UserInfo> getUserInfo() {
        LoginResponse.UserInfo userInfo = new LoginResponse.UserInfo();
        userInfo.setId(1L);
        userInfo.setUsername("admin");
        userInfo.setRealName("系统管理员");
        userInfo.setEmail("admin@archive.com");
        userInfo.setPhone("13800138000");
        userInfo.setDepartment("信息技术部");
        userInfo.setPosition("系统管理员");

        return Result.success(userInfo);
    }

    @PostMapping("/logout")
    public Result<Void> logout() {
        return Result.success();
    }
}
