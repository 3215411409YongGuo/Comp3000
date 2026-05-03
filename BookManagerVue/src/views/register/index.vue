<template>
  <div class="login-container">
    <el-form
      ref="loginForm"
      :model="loginForm"
      :rules="loginRules"
      class="login-form"
      auto-complete="on"
      label-position="left"
    >
      <!-- Title -->
      <div class="title-container">
        <h3 class="title">Library Management System - Registration Interface</h3>
      </div>
      <!-- User name -->
      <el-form-item prop="username">
        <span class="svg-container">
          <svg-icon icon-class="user" />
        </span>
        <el-input
          ref="username"
          v-model="loginForm.username"
          placeholder="Please enter your username"
          name="username"
          type="text"
          tabindex="1"
          auto-complete="on"
        />
      </el-form-item>
      <!-- Password -->
      <el-form-item prop="password">
        <span class="svg-container">
          <svg-icon icon-class="password" />
        </span>
        <el-input
          ref="password"
          v-model="loginForm.password"
          type="password"
          placeholder="Please enter the password."
          name="password"
          tabindex="2"
          auto-complete="on"
        />
      </el-form-item>
      <!-- Confirm password -->
      <el-form-item prop="repeat">
        <span class="svg-container">
          <svg-icon icon-class="password" />
        </span>
        <el-input
          ref="repeat"
          v-model="loginForm.repeat"
          type="password"
          placeholder="Please confirm the password."
          name="repeat"
          tabindex="3"
          auto-complete="on"
          @keyup.enter.native="handleRight"
        />
      </el-form-item>

      <!-- Login button -->
      <div style="height: 40px; margin-bottom: 30px">
        <el-button :loading="loading" type="primary" style="width: 48%; float: left" @click.native.prevent="handleRight">Confirm</el-button>
        <el-button :loading="loading" type="success" style="width: 48%; float: right" @click.native.prevent="handleBack">Return to Login</el-button>
      </div>
    </el-form>
  </div>
</template>

<script>
import { register } from '@/api/user'

export default {
  name: 'Login',
  data() {
    const validateRepeat = (rule, value, callback) => {
      if (value !== this.loginForm.password) {
        callback(new Error('The passwords entered twice are inconsistent!'))
      } else {
        callback()
      }
    }
    return {
      loginForm: {
        username: '',
        password: '',
        repeat: ''
      },
      loginRules: {
        username: [
          { required: true, message: 'Please enter your username', trigger: 'blur' }
        ],
        password: [{ required: true, message: 'Please enter the password', trigger: 'blur' }],
        repeat: [
          { required: true, message: 'Please enter the password again', trigger: 'blur' },
          { trigger: 'blur', validator: validateRepeat }
        ]
      },
      loading: false
    }
  },
  methods: {
    handleRight() {
      this.$refs.loginForm.validate((valid) => {
        if (valid) {
          register({ username: this.loginForm.username, password: this.loginForm.password}).then((res) => {
            if (res === 0) {
              this.$message.error('Registration failed. It is possible that the account is duplicated')
            } else {
              this.$message.success('Registration successful')
            }
          })
        } else {
          console.log('Submission is not allowed!')
          return false
        }
      })
    },
    handleBack() {
      this.$router.push('/login')
    }
  }
}
</script>

<style lang="scss">
/* Fix the issue of inconsistent background color of the input field and the color change of the cursor. */
/* Detail see https://github.com/PanJiaChen/vue-element-admin/pull/927 */

$bg: #283443;
$light_gray: #fff;
$cursor: #fff;

@supports (-webkit-mask: none) and (not (cater-color: $cursor)) {
  .login-container .el-input input {
    color: $cursor;
  }
}

/* reset element-ui css */
.login-container {
  .el-input {
    display: inline-block;
    height: 47px;
    width: 85%;

    input {
      background: transparent;
      border: 0px;
      -webkit-appearance: none;
      border-radius: 0px;
      padding: 12px 5px 12px 15px;
      color: $light_gray;
      height: 47px;
      caret-color: $cursor;

      &:-webkit-autofill {
        box-shadow: 0 0 0px 1000px $bg inset !important;
        -webkit-text-fill-color: $cursor !important;
      }
    }
  }

  .el-form-item {
    border: 1px solid rgba(255, 255, 255, 0.1);
    background: rgba(0, 0, 0, 0.1);
    border-radius: 5px;
    color: #454545;
  }
  .el-icon-arrow-up:before {
    content: "";
  }
}
</style>

<style lang="scss" scoped>
$bg: #2d3a4b;
$dark_gray: #889aa4;
$light_gray: #eee;

.login-container {
  min-height: 100%;
  width: 100%;
  background-color: $bg;
  overflow: hidden;

  .login-form {
    position: relative;
    width: 520px;
    max-width: 100%;
    padding: 160px 35px 0;
    margin: 0 auto;
    overflow: hidden;
  }

  .tips {
    font-size: 14px;
    color: #fff;
    margin-bottom: 10px;

    span {
      &:first-of-type {
        margin-right: 16px;
      }
    }
  }

  .svg-container {
    padding: 6px 5px 6px 15px;
    color: $dark_gray;
    vertical-align: middle;
    width: 30px;
    display: inline-block;
  }

  .title-container {
    position: relative;

    .title {
      font-size: 26px;
      color: $light_gray;
      margin: 0px auto 40px auto;
      text-align: center;
      font-weight: bold;
    }
  }

  .show-pwd {
    position: absolute;
    right: 10px;
    top: 7px;
    font-size: 16px;
    color: $dark_gray;
    cursor: pointer;
    user-select: none;
  }
}
</style>
