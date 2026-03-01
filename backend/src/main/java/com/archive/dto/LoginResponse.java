package com.archive.dto;

import lombok.Data;

@Data
public class LoginResponse {
    private String token;
    private UserInfo userInfo;

    @Data
    public static class UserInfo {
        private Long id;
        private String username;
        private String realName;
        private String email;
        private String phone;
        private String department;
        private String position;
    }
}
