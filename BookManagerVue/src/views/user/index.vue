<template>
  <div class="app-container">
    <!-- Top function -->
    <div class="filter-container" style="margin-bottom: 15px">
      <!-- User name input -->
      <el-input v-model="queryParam.username" placeholder="User name" style="width: 200px;" class="filter-item" @keyup.enter.native="handleFilter" />
      <!-- Some buttons -->
      <el-button v-waves class="filter-item" type="primary" icon="el-icon-search" @click="handleFilter">
        Search
      </el-button>
      <el-button v-waves class="filter-item" type="primary" icon="el-icon-search" @click="handleShowAll">
        Display all
      </el-button>
      <el-button class="filter-item" style="margin-left: 10px;" type="primary" icon="el-icon-edit" @click="handleCreate">
        Add a user
      </el-button>
      <el-button class="filter-item" style="margin-left: 10px;" type="danger" icon="el-icon-delete" @click="handleDeleteSome">
        Batch deletion
      </el-button>
    </div>

    <!--Pop-up box-->
    <el-dialog :title="formTitle" :visible.sync="dialogFormVisible" width="30%">
      <!--Ordinary form-->
      <el-form :model="form" :rules="rules" ref="ruleForm" label-width="80px">

        <el-form-item label="Name" prop="username" label-width="90px">
          <el-input v-model="form.username"></el-input>
        </el-form-item>

        <el-form-item label="Password" prop="userpassword" label-width="90px">
          <el-input v-model="form.userpassword"></el-input>
        </el-form-item>

        <el-form-item label="Identity" prop="isadmin">
          <el-radio v-model="form.isadmin" :label="1">Administrator</el-radio>
          <el-radio v-model="form.isadmin" :label="0">Reader</el-radio>
        </el-form-item>
      </el-form>

      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">Cancel</el-button>
        <el-button type="primary" @click="submitForm">Confirmed</el-button>
      </div>
    </el-dialog>

    <!--Data table-->
    <el-table
        ref="multipleTable"
        :data="tableData"
        border
        style="width: 100%">
      <el-table-column
          fixed
          type="selection"
          width="55">
      </el-table-column>
      <el-table-column
          fixed
          prop="userid"
          label="Number"
          width="100">
      </el-table-column>
      <el-table-column
          prop="username"
          label="User name"
          show-overflow-tooltip>
      </el-table-column>
      <el-table-column
          prop="userpassword"
          label="User password"
          show-overflow-tooltip>
      </el-table-column>
      <el-table-column
          label="User identity"
          show-overflow-tooltip>
          <template slot-scope="scope">
            <el-tag v-if="scope.row.isadmin === 1" type="warning">Administrator</el-tag>
            <el-tag v-else type="success">Reader</el-tag>
          </template>
      </el-table-column>
      <el-table-column
          fixed="right"
          label="Operation"
          width="150">
        <template slot-scope="scope">
          <el-button @click="handleUpdate(scope.row)" type="primary" size="small" style="margin-right: 14px;">Edit</el-button>
          <el-button @click="handleDelete(scope.row,scope.$index)" type="danger" size="small" style="margin-left: -8px;">Delete</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!--Pagination bar-->
    <el-pagination
        background
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        :current-page.sync="queryParam.page"
        :page-sizes="[5, 10, 20, 50]"
        :page-size="queryParam.limit"
        layout="total, sizes, prev, pager, next, jumper"
        :total="recordTotal"
        style="margin-top: 15px">
    </el-pagination>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import waves from '@/directive/waves' // waves directive
import { getCount,queryUsers,queryUsersByPage,addUser,deleteUser,deleteUsers,updateUser }
from '@/api/user'

export default {
  name: 'Bookinfo',
  directives: { waves },
  // After creation
  created() {
    // Retrieve the information of the first page of the data table from the server.
    queryUsersByPage(this.queryParam).then(res => {
      console.log('The data on the homepage has been successfully obtained',res)
      this.tableData = res.data
      this.recordTotal = res.count
    })
  },
  methods: {
    // Page size change listener
    handleSizeChange(curSize) {
      const params = this.queryParam
      params.limit = curSize
      queryUsersByPage(params).then(res => {
            console.log('Paginated data fetched successfully',res)
            this.tableData = res.data
            this.recordTotal = res.count
      })
    },

    // Click on the page change listener method
    handleCurrentChange(curPage) {
      const params = this.queryParam
      params.page = curPage
      queryUsersByPage(params).then(res => {
            console.log('Paginated data fetched successfully',res)
            this.tableData = res.data
            this.recordTotal = res.count
      })
    },

    // Search
    handleFilter() {
      this.queryParam.page = 1
      queryUsersByPage(this.queryParam).then(res => {
        if(res.code === 0) {
          this.tableData = res.data
          this.recordTotal = res.count
        }
      })
    },

    // Show all
    handleShowAll() {
      this.queryParam.page = 1
      this.queryParam.username = null
      queryUsersByPage(this.queryParam).then(res => {
        if(res.code === 0) {
          this.tableData = res.data
          this.recordTotal = res.count
        }
      })
    },

    // Click to add a record
    handleCreate() {
      // The form is in the added state.
      this.formType = 0
      // Insert empty data into the form
      this.form = {
        userid: null,
        username: 'Jason',
        userpassword: '123456',
        isadmin: 1,
      }
      // Display the form box
      this.dialogFormVisible = true
    },

    // Click to edit the record
    handleUpdate(row) {
      // The form is in editing mode.
      this.formType = 1
      // Insert the row data into the form
      this.form = {
        userid: row.userid,
        username: row.username,
        userpassword: row.userpassword,
        isadmin: row.isadmin,
      }
      // Display the form box
      this.dialogFormVisible = true
    },

    // The submission form for additions and updates
    submitForm() {
      if (this.formType === 0) {  // Add a record
        addUser(this.form).then(res => {
          if(res === 1) {
            this.$message.success('Record added successfully')
            // Go to the end
            getCount().then(res => {
              this.recordTotal = res
              this.queryParam.page = Math.ceil(this.recordTotal / this.queryParam.limit)
              this.handleCurrentChange(this.queryParam.page)
            })
          } else {
            this.$message.error('Failed to add record')
          }
          this.dialogFormVisible = false  // Close the dialog box
        })
      } else if(this.formType === 1) {  //Update Log
        updateUser(this.form).then(res => {
          if(res === 1) {
            this.$message.success('The record update was successful.')
            this.handleCurrentChange(this.queryParam.page)
          } else {
            this.$message.error('Failed to update the record')
          }
          this.dialogFormVisible = false  // Close the dialog box
        })
      }
    },

    // Delete the record
    handleDelete(row, index) {
      this.$confirm('Are you sure you want to delete this record?', 'Tip', {
        confirmButtonText: 'Sure',
        cancelButtonText: 'Cancel',
        type: 'warning'
      }).then(() => {
        deleteUser(row).then(res => {
          if(res === 1) {
            this.$message.success('The record was deleted successfully.')
            this.tableData.splice(index, 1)
            // If you have deleted something, go back to the previous page.
            if(this.tableData.length === 0) {
              this.queryParam.page = this.queryParam.page - 1
              this.handleCurrentChange(this.queryParam.page)
            }
          } else {
            this.$message.error('Failed to delete the record')
          }
        })
      })
    },

    // Delete some
    handleDeleteSome() {
      this.$confirm('Are you sure you want to delete these records?', 'Tip', {
        confirmButtonText: 'Sure',
        cancelButtonText: 'Cancel',
        type: 'warning'
      }).then(() => {
        // Obtain the array of selected objects
        const items = this.$refs.multipleTable.selection
        deleteUsers(items).then(res => {
          if(res > 0) {
            this.$message.success('Delete' + res + 'records successfully')
            if(this.tableData.length === res) {  //If all the content on this page is deleted
              //This page is the previous page.
              if(this.queryParam.page !== 0) {
                this.queryParam.page = this.queryParam.page - 1
              }
            }
            // Reload the current page
            this.handleCurrentChange(this.queryParam.page)
          } else {
            this.$message.error('Failed to delete the record')
          }
        })
      })
    },

  },
  data() {
    return {
      // Table data
      tableData: [],
      // Total number of records
      recordTotal: 0,
      // Query parameters
      queryParam: {
        page: 1,
        limit: 10,
        username: null
      },
      // Dialog box form display
      dialogFormVisible: false,
      // Form type (Add data: 0, Modify data: 1)
      formType: 0,
      // Form data
      form: {
        userid: null,
        username: '',
        userpassword: '',
        isadmin: 1
      },
      rules: {
        username: [
          { required: true, message: 'Please enter your username', trigger: 'blur' }
        ],
        userpassword: [
          { required: true, message: 'Please enter your user password', trigger: 'blur' }
        ]
      },
    }
  },
  computed: {
    // Obtain user information
    ...mapGetters(['id','name','roles']),
    // Calculate the form title based on the form type
    formTitle() {
      return this.formType === 0 ? 'Add records' : 'Edit record'
    }
  }
}

</script>

<style scoped>
  .avatar-uploader .el-upload {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }
  .avatar-uploader .el-upload:hover {
    border-color: #409EFF;
  }
  .avatar-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 178px;
    height: 178px;
    line-height: 178px;
    text-align: center;
  }
  .avatar {
    width: 150px;
    height: 200px;
    display: block;
  }
</style>
