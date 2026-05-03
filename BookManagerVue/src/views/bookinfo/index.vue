<template>
  <div class="app-container">
    <!-- Top function -->
    <div class="filter-container" style="margin-bottom: 15px">
      <!-- Book title input -->
      <el-input v-model="queryParam.bookname" placeholder="Title of Book" style="width: 200px;" class="filter-item" @keyup.enter.native="handleFilter" />
      <!-- Author Input -->
      <el-input v-model="queryParam.bookauthor" placeholder="Author" style="width: 200px;" class="filter-item" @keyup.enter.native="handleFilter" />
      <!-- Type selection -->
      <el-select v-model="queryParam.booktypeid" filterable placeholder="Type" clearable class="filter-item" style="width: 200px">
        <el-option v-for="item in typeData" :key="item.booktypeid" :label="item.booktypename" :value="item.booktypeid" />
      </el-select>
      <!-- Some buttons -->
      <el-button v-waves class="filter-item" type="primary" icon="el-icon-search" @click="handleFilter">
        Search
      </el-button>
      <el-button v-waves class="filter-item" type="primary" icon="el-icon-search" @click="handleShowAll">
        Display all
      </el-button>
      <el-button v-permission="['admin']" class="filter-item" style="margin-left: 10px;" type="primary" icon="el-icon-edit" @click="handleCreate">
        Add books
      </el-button>
      <el-button v-permission="['admin']" class="filter-item" style="margin-left: 10px;" type="danger" icon="el-icon-delete" @click="handleDeleteSome">
        Batch delete
      </el-button>
    </div>

    <!--Pop-up box-->
    <el-dialog :title="formTitle" :visible.sync="dialogFormVisible" width="40%">
      <el-row>
        <el-col :span="16">
          <!--Ordinary form-->
          <el-form :model="form" :rules="rules" ref="ruleForm" label-width="80px">

            <el-form-item label="Title of the Book" prop="bookname" label-width="140px">
              <el-input v-model="form.bookname"></el-input>
            </el-form-item>

            <el-form-item label="Author" prop="bookauthor">
              <el-input v-model="form.bookauthor"></el-input>
            </el-form-item>

            <el-form-item label="Price" prop="bookprice" label-width="80px">
              <el-input v-model="form.bookprice"></el-input>
            </el-form-item>

            <el-form-item label="Book type" prop="booktypeid" label-width="95px">
              <el-select v-model="form.booktypeid" placeholder="Please select the type">
                <el-option
                    v-for="item in typeData"
                    :key="item.booktypeid"
                    :label="item.booktypename"
                    :value="item.booktypeid">
                </el-option>
              </el-select>
            </el-form-item>

            <el-form-item label="Book description" prop="bookdesc" label-width="140px">
              <el-input type="textarea" v-model="form.bookdesc"></el-input>
            </el-form-item>
          </el-form>
        </el-col>
        <el-col :span="8">
          <div align="center">
            <h3>Upload the cover</h3>
            <!--Upload pictures-->
            <el-upload
                class="avatar-uploader"
                action="http://localhost:8092/BookManager/update/updateImg"
                :show-file-list="false"
                :on-success="handleAvatarSuccess"
                :before-upload="beforeAvatarUpload">
              <img v-if="form.bookimg" :src="form.bookimg" class="avatar" alt="The cover cannot be displayed.">
              <i v-else class="el-icon-plus avatar-uploader-icon"></i>
            </el-upload>
          </div>

        </el-col>
      </el-row>

      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">Cancel</el-button>
        <el-button type="primary" @click="submitForm">Sure</el-button>
      </div>
    </el-dialog>

    <!--Pop-up Box 2-->
    <el-dialog title="Select a user" :visible.sync="dialogFormVisible2" width="400px">
      <el-form :model="form2">
        <el-form-item label="User name" prop="userid" label-width="80px">
              <el-select v-model="form2.booktypeid" placeholder="Please select a user">
                <el-option
                    v-for="item in userData"
                    :key="item.userid"
                    :label="item.username"
                    :value="item.userid">
                </el-option>
              </el-select>
            </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible2 = false">Cancel</el-button>
        <el-button type="primary" @click="submitForm2">Sure</el-button>
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
          prop="bookid"
          label="Number"
          width="100">
      </el-table-column>
      <el-table-column
          v-if="roleIsAdmin === false"
          label="Book cover"
          width="155">
          <template slot-scope="scope">
            <el-image :src="scope.row.bookimg" style="width: 130px; height: 180px"></el-image>
          </template>
      </el-table-column>
      <el-table-column
          prop="bookname"
          label="Title of the Book"
          width="150"
          show-overflow-tooltip>
      </el-table-column>
      <el-table-column
          prop="bookauthor"
          label="Author"
          width="100"
          show-overflow-tooltip>
      </el-table-column>
      <el-table-column
          prop="bookprice"
          label="Price"
          width="100">
           <template slot-scope="scope">
    ￡{{ scope.row.bookprice }}
  </template>
      </el-table-column>
      <el-table-column
          prop="booktypename"
          label="Type"
          width="100"
          show-overflow-tooltip>
      </el-table-column>
      <el-table-column
          prop="bookdesc"
          label="Book Description"
          min-width="300"
          show-overflow-tooltip>
      </el-table-column>
      <el-table-column
          label="Status"
          width="100">
          <template slot-scope="scope">
            <span v-if="scope.row.isborrowed === 1" style="color: red">Lent</span>
            <span v-else style="color: #1aac1a">Not lent</span>
          </template>
      </el-table-column>
      <el-table-column
          fixed="right"
          label="Operation"
          :width="roleIsAdmin?'240px':'110px'">
        <template slot-scope="scope">
          <el-button v-permission="['admin']" @click="handleUpdate(scope.row)" type="primary" size="small">Edit</el-button>
          <el-button v-permission="['admin']" @click="handleDelete(scope.row,scope.$index)" type="danger" size="small">Delete</el-button>
          <el-button @click="handleBorrow(scope.row)" type="success" size="small">Borrow</el-button>
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
import permission from '@/directive/permission/index.js' // Permission determination instruction
import waves from '@/directive/waves' // waves directive
import {
  getCount,
  queryBookInfosByPage,
  addBookInfo,
  deleteBookInfo,
  deleteBookInfos,
  updateBookInfo
} from '@/api/bookinfo'
import { queryBookTypes } from '@/api/booktype'
import { borrowBook } from '@/api/borrow'
import { queryUsers } from '@/api/user'

export default {
  name: 'Bookinfo',
  directives: { waves, permission },
  // After creation
  created() {
    // Retrieve the information of the first page of the data table from the server.
    queryBookInfosByPage(this.queryParam).then(res => {
      console.log('The data on the homepage has been successfully obtained',res)
      this.tableData = res.data
      this.recordTotal = res.count
    })
    // Obtain all the book types from the server
    queryBookTypes().then(res => {
      console.log('The type of books has been successfully identified',res)
      this.typeData = res
    })
  },
  mounted() {
    if (this.roleIsAdmin === false) {
      this.queryParam.limit = 5
      this.handleSizeChange(this.queryParam.limit)
    }
  },
  methods: {
    // Page size change listener
    handleSizeChange(curSize) {
      const params = this.queryParam
      params.limit = curSize
      queryBookInfosByPage(params).then(res => {
            console.log('Paginated data fetched successfully',res)
            this.tableData = res.data
            this.recordTotal = res.count
      })
    },

    // Click on the page change listener method
    handleCurrentChange(curPage) {
      const params = this.queryParam
      params.page = curPage
      queryBookInfosByPage(params).then(res => {
            console.log('Paginated data fetched successfully',res)
            this.tableData = res.data
            this.recordTotal = res.count
      })
    },

    // Search for books
    handleFilter() {
      this.queryParam.page = 1
      queryBookInfosByPage(this.queryParam).then(res => {
        if(res.code === 0) {
          this.tableData = res.data
          this.recordTotal = res.count
        }
      })
    },

    // Show all
    handleShowAll() {
      this.queryParam.page = 1
      this.queryParam.bookname = null
      this.queryParam.bookauthor = null
      this.queryParam.booktypeid = null
      queryBookInfosByPage(this.queryParam).then(res => {
        if(res.code === 0) {
          this.tableData = res.data
          this.recordTotal = res.count
        }
      })
    },

    // Image upload success listener
    handleAvatarSuccess(res, file) {
      console.log(res)
      console.log(file)
      if(res.code === 0) {
        this.$message.success('Uploaded successfully');
        this.form.bookimg = res.data
      } else {
        this.$message.error('Upload failed. Please contact the administrator');
      }
    },

    // Listening before uploading the image
    beforeAvatarUpload(file) {
      const isJPG = file.type === 'image/jpeg';
      const isLt2M = file.size / 1024 / 1024 < 2;

      if (!isJPG) {
        this.$message.error('The cover image uploaded can only be in JPG format!');
      }
      if (!isLt2M) {
        this.$message.error('The size of the cover image uploaded cannot exceed 2MB!');
      }
      return isJPG && isLt2M;
    },

    // Click to add a record
    handleCreate() {
      // Obtain all the book types from the server
      queryBookTypes().then(res => {
        console.log('The type of books has been successfully identified',res)
        this.typeData = res
      })
      // The form is in the added state.
      this.formType = 0
      // Insert empty data into the form
      this.form = {
        bookid: null,
        bookname: 'A Dream in Red Mansions',
        bookauthor: 'Cao Xueqin',
        bookprice: '35.5',
        booktypeid: 1,
        bookdesc: 'Write a biography for the boudoir',
        isborrowed: 0,
        
      }
      // Display the form box
      this.dialogFormVisible = true
    },

    // Click to edit the record
    handleUpdate(row) {
      // Obtain all the book types from the server
      queryBookTypes().then(res => {
        console.log('The type of books has been successfully identified',res)
        this.typeData = res
      })
      // The form is in editing mode.
      this.formType = 1
      // Insert the row data into the form
      this.form = {
        bookid: row.bookid,
        bookname: row.bookname,
        bookauthor: row.bookauthor,
        bookprice: row.bookprice,
        booktypeid: row.booktypeid,
        bookdesc: row.bookdesc,
        isborrowed: row.isborrowed,
        bookimg: row.bookimg
      }
      // Display the form box
      this.dialogFormVisible = true
    },

    // Click to borrow books
    handleBorrow(row) {
      if (this.roleIsAdmin) {
        // Display the form box
        this.dialogFormVisible2 = true
        // Obtain book information
        this.form2.bookid = row.bookid

        // Obtain user information
        queryUsers().then(res => {
          this.userData = res
        })
      } else {
        this.$confirm('Are you sure you want to borrow books?', 'Tip').then(() => {
          borrowBook(this.id, row.bookid).then(res => {
            if(res === 1) {
              this.$message.success('Borrowed books successfully')
              this.handleCurrentChange(this.queryParam.page)
            } else {
              this.$message.error('Failed to borrow books')
            }
            this.dialogFormVisible2 = false // Close the dialog box
          })
        })
      }
    },

    // The submission form for additions and updates
    submitForm() {
      if (this.formType === 0) {  // Add a record
        addBookInfo(this.form).then(res => {
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
        updateBookInfo(this.form).then(res => {
          if(res === 1) {
            this.$message.success('The record update was successful')
            this.handleCurrentChange(this.queryParam.page)
          } else {
            this.$message.error('Failed to update the record')
          }
          this.dialogFormVisible = false  // Close the dialog box
        })
      }
    },

    // The form for submitting the request to borrow books
    submitForm2() {
      borrowBook(this.form2.userid, this.form2.bookid).then(res => {
        if(res === 1) {
          this.$message.success('Borrowed books successfully')
          this.handleCurrentChange(this.queryParam.page)
        } else {
          this.$message.error('Failed to borrow books')
        }
        this.dialogFormVisible2 = false // Close the dialog box
      })
    },

    // Delete the record
    handleDelete(row, index) {
      this.$confirm('Are you sure you want to delete this record?', 'Tip', {
        confirmButtonText: 'Sure',
        cancelButtonText: 'Cancel',
        type: 'warning'
      }).then(() => {
        deleteBookInfo(row).then(res => {
          if(res === 1) {
            this.$message.success('The record was deleted successfully')
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
        deleteBookInfos(items).then(res => {
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
      // Book type data
      typeData: [],
      // User data
      userData: [],
      // Query parameters
      queryParam: {
        page: 1,
        limit: 10,
        bookname: null,
        bookauthor: null,
        booktypeid: null
      },
      // Dialog box form display
      dialogFormVisible: false,
      dialogFormVisible2: false,
      // Form type (Add data: 0, Modify data: 1)
      formType: 0,
      // Form data
      form: {
        bookid: null,
        bookname: '',
        bookauthor: '',
        bookprice: 0,
        booktypeid: 1,
        bookdesc: '',
        isborrowed: 0,
        bookimg: ''
      },
      form2: {
        userid: 1,
        bookid: 1
      },
      rules: {
        bookname: [
          { required: true, message: 'Please enter the name of the book', trigger: 'blur' }
        ],
        bookauthor: [
          { required: true, message: 'Please enter the author', trigger: 'blur' }
        ],
        bookprice: [
          { required: true, message: 'Please enter the price', trigger: 'blur' }
        ],
        booktypeid: [
          { required: true, message: 'Please select the type', trigger: 'blur' }
        ],
        bookdesc: [
          { required: true, message: 'Please enter the description', trigger: 'blur' }
        ],
        isborrowed: [
          { required: true, message: 'Please select the status', trigger: 'blur' }
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
    },
    roleIsAdmin() {
      if(this.roles[0] === 'admin') return true
      else return false
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
