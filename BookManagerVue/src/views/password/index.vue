<template>
  <div class="app-container">
    <el-form
      ref="form"
      :model="form"
      :rules="passwordRules"
      label-width= "250px"
    >
      <el-form-item label="Old password" prop="oldPassword">
        <el-input
          v-model="form.oldPassword"
          type="password"
          placeholder="Please enter the old password"
          style="width: 300px"
        />
      </el-form-item>
      <el-form-item label="New password" prop="newPassword">
        <el-input
          v-model="form.newPassword"
          type="password"
          placeholder="Please enter the new password"
          style="width: 300px"
        />
      </el-form-item>
      <el-form-item label="Confirm the new password" prop="repeat">
        <el-input
          v-model="form.repeat"
          type="password"
          placeholder="Please enter the new password again"
          style="width: 300px"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit">Change password</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { alterPassword } from '@/api/user'
export default {
  data() {
    const validateRepeat = (rule, value, callback) => {
      if (value !== this.form.newPassword) {
        callback(new Error('Passwords do not match!'))
      } else {
        callback()
      }
    }
    return {
      form: {
        oldPassword: '',
        newPassword: '',
        repeat: ''
      },
      passwordRules: {
        oldPassword: [
          { required: true, message: 'Please enter the old password', trigger: 'blur' }
        ],
        newPassword: [
          { required: true, message: 'Please enter the new password', trigger: 'blur' }
        ],
        repeat: [
          { required: true, message: 'Please enter a new password again', trigger: 'blur' },
          { trigger: 'blur', validator: validateRepeat }
        ]
      }
    }
  },
  methods: {
    onSubmit() {
      this.$refs.form.validate(valid => {
        if (valid) {
          const isadmin = this.roles[0] === 'admin' ? 1 : 0
          console.log(isadmin)
          alterPassword({ userid: this.id, username: this.name, isadmin: isadmin, oldPassword: this.form.oldPassword, newPassword: this.form.newPassword }).then(res => {
            if(res === 0) this.$message.error('The old password is incorrect')
            else this.$message.success('Edit successful')
          })
        } else {
          console.log('Submission is not allowed!')
          return
        }
      })
      
    }
  },
  computed: {
    // Obtain user information
    ...mapGetters(['id','name','roles']),
  }
}
</script>

<style>
</style>
