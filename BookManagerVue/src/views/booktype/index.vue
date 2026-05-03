<template>
  <div class="app-container">
    <!-- Top function -->
    <div class="filter-container" style="margin-bottom: 15px">
      <!-- Type name input -->
      <el-input v-model="queryParam.booktypename" placeholder="Type name" style="width: 200px;" class="filter-item" @keyup.enter.native="handleFilter" />
      <!-- Some buttons -->
      <el-button v-waves class="filter-item" type="primary" icon="el-icon-search" @click="handleFilter">
        Search
      </el-button>
      <el-button v-waves class="filter-item" type="primary" icon="el-icon-search" @click="handleShowAll">
        Display all
      </el-button>
      <el-button class="filter-item" style="margin-left: 10px;" type="primary" icon="el-icon-edit" @click="handleCreate">
        Add type
      </el-button>
      <el-button class="filter-item" style="margin-left: 10px;" type="danger" icon="el-icon-delete" @click="handleDeleteSome">
        Batch Delete
      </el-button>
    </div>

    <!--Pop-up box-->
    <el-dialog :title="formTitle" :visible.sync="dialogFormVisible" width="30%">
      <!--Ordinary form-->
      <el-form :model="form" :rules="rules" ref="ruleForm" label-width="80px">

        <el-form-item label="Type name" prop="booktypename" label-width="140px">
          <el-input v-model="form.booktypename"></el-input>
        </el-form-item>

        <el-form-item label="Type description" prop="booktypedesc" label-width="140px">
          <el-input type="textarea" v-model="form.booktypedesc"></el-input>
        </el-form-item>
      </el-form>

      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">Cancel</el-button>
        <el-button type="primary" @click="submitForm">Sure</el-button>
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
          prop="booktypeid"
          label="Number"
          width="100">
      </el-table-column>
      <el-table-column
          prop="booktypename"
          label="Type name"
          show-overflow-tooltip>
      </el-table-column>
      <el-table-column
          prop="booktypedesc"
          label="Type description"
          show-overflow-tooltip>
      </el-table-column>
      <el-table-column
          fixed="right"
          label="Operation"
          width="150">
        <template slot-scope="scope">
          <el-button @click="handleUpdate(scope.row)" type="primary" size="small" style="margin-right: 15px;">Edit</el-button>
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
import { getCount,queryBookTypes,queryBookTypesByPage,addBookType,deleteBookType,deleteBookTypes,updateBookType }
from '@/api/booktype'

export default {
  name: 'Bookinfo',
  directives: { waves },
  // After creation
  created() {
    // Retrieve the information of the first page of the data table from the server.
    queryBookTypesByPage(this.queryParam).then(res => {
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
      queryBookTypesByPage(params).then(res => {
            console.log('Paginated data fetched successfully',res)
            this.tableData = res.data
            this.recordTotal = res.count
      })
    },

    // Click on the page change listener method
    handleCurrentChange(curPage) {
      const params = this.queryParam
      params.page = curPage
      queryBookTypesByPage(params).then(res => {
            console.log('Paginated data fetched successfully',res)
            this.tableData = res.data
            this.recordTotal = res.count
      })
    },

    // Search
    handleFilter() {
      this.queryParam.page = 1
      queryBookTypesByPage(this.queryParam).then(res => {
        if(res.code === 0) {
          this.tableData = res.data
          this.recordTotal = res.count
        }
      })
    },

    // Show all
    handleShowAll() {
      this.queryParam.page = 1
      this.queryParam.booktypename = null
      queryBookTypesByPage(this.queryParam).then(res => {
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
        booktypeid: null,
        booktypename: 'Novel Haha',
        booktypedesc: 'appeals'
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
        booktypeid: row.booktypeid,
        booktypename: row.booktypename,
        booktypedesc: row.booktypedesc
      }
      // Display the form box
      this.dialogFormVisible = true
    },

    // The submission form for additions and updates
    submitForm() {
      if (this.formType === 0) {  // Add a record
        addBookType(this.form).then(res => {
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
        updateBookType(this.form).then(res => {
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
        deleteBookType(row).then(res => {
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
        deleteBookTypes(items).then(res => {
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
        booktypename: null
      },
      // Dialog box form display
      dialogFormVisible: false,
      // Form type (Add data: 0, Modify data: 1)
      formType: 0,
      // Form data
      form: {
        bookid: null,
        booktypename: '',
        booktypedesc: ''
      },
      rules: {
        booktypename: [
          { required: true, message: 'Please enter the name of the book type', trigger: 'blur' }
        ],
        booktypedesc: [
          { required: true, message: 'Please enter the description of the book type', trigger: 'blur' }
        ]
      },
    }
  },
  computed: {
    // Obtain user information
    ...mapGetters(['id','name','roles']),
    // Calculate the form title based on the form type
    formTitle() {
      return this.formType === 0 ? 'Add records' : 'Edit records'
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
