<template>
  <div class="app-container">
    <!-- Top function -->
    <div class="filter-container" style="margin-bottom: 15px">
      <!-- User name input -->
      <el-input v-permission="['admin']" v-model="queryParam.username" placeholder="User name" style="width: 200px;" class="filter-item" @keyup.enter.native="handleFilter" />
      <!-- Book title input -->
      <el-input v-model="queryParam.bookname" placeholder="Title of the Book" style="width: 200px;" class="filter-item" @keyup.enter.native="handleFilter" />
      <!-- Some buttons -->
      <el-button v-waves class="filter-item" type="primary" icon="el-icon-search" @click="handleFilter">
        Search
      </el-button>
      <el-button v-waves class="filter-item" type="primary" icon="el-icon-search" @click="handleShowAll">
        Display all
      </el-button>
      <el-button v-permission="['admin']" class="filter-item" style="margin-left: 10px;" type="danger" icon="el-icon-delete" @click="handleDeleteSome">
        Batch deletion
      </el-button>
      <!-- <el-button class="filter-item" style="margin-left: 10px;" type="success" icon="el-icon-edit" @click="handleReturnSome">
        Batch return of books
      </el-button> -->
    </div>

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
          prop="borrowid"
          label="Number"
          width="100">
      </el-table-column>
      <el-table-column
          prop="username"
          label="User name"
          show-overflow-tooltip>
      </el-table-column>
      <el-table-column
          prop="bookname"
          label="Title of the Book"
          show-overflow-tooltip>
      </el-table-column>
      <el-table-column
          prop="borrowtimestr"
          label="Borrowing time">
      </el-table-column>
      <el-table-column
          label="Return time">
          <template slot-scope="scope">
            <span v-if="scope.row.returntimestr === null || scope.row.returntimestr === ''" style="color: red">Waiting to return the book</span>
            <span v-else style="color: #1aac1a">{{scope.row.returntimestr}}</span>
          </template>
      </el-table-column>
      <el-table-column
          fixed="right"
          label="Operation"
          :width="roleIsAdmin?'180px':'110px'">
        <template slot-scope="scope">
          <el-button v-permission="['admin']" @click="handleDelete(scope.row,scope.$index)" type="danger" size="small">Delete</el-button>
          <el-button @click="handleReturn(scope.row,scope.$index)" type="success" size="small">Return</el-button>
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
import { getCount,queryBorrows,queryBorrowsByPage,addBorrow,deleteBorrow,deleteBorrows,updateBorrow,returnBook } from '@/api/borrow'

export default {
  name: 'Bookinfo',
  directives: { waves, permission },
  // 创建后
  created() {
    // Retrieve the information of the first page of the data table from the server.
    queryBorrowsByPage(this.queryParam).then(res => {
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
      queryBorrowsByPage(params).then(res => {
            console.log('The paging data acquisition was successful',res)
            this.tableData = res.data
            this.recordTotal = res.count
      })
    },

    // Click on the page change listener method
    handleCurrentChange(curPage) {
      const params = this.queryParam
      params.page = curPage
      queryBorrowsByPage(params).then(res => {
            console.log('Successfully retrieved paginated data',res)
            this.tableData = res.data
            this.recordTotal = res.count
      })
    },

    // Search
    handleFilter() {
      this.queryParam.page = 1
      queryBorrowsByPage(this.queryParam).then(res => {
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
      this.queryParam.bookname = null
      queryBorrowsByPage(this.queryParam).then(res => {
        if(res.code === 0) {
          this.tableData = res.data
          this.recordTotal = res.count
        }
      })
    },

    // Delete the record
    handleDelete(row, index) {
      this.$confirm('Are you sure you want to delete this record?', 'Tip', {
        confirmButtonText: 'Sure',
        cancelButtonText: 'Cancel',
        type: 'warning'
      }).then(() => {
        deleteBorrow(row).then(res => {
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
        deleteBorrows(items).then(res => {
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

    // Return the books
    handleReturn(row, index) {
      this.$confirm('Are you sure you want to return the book?', 'Tip', {
        confirmButtonText: 'Sure',
        cancelButtonText: 'Cancel',
        type: 'warning'
      }).then(() => {
        returnBook(row.borrowid, row.bookid).then(res => {
          if(res === 1) {
            this.$message.success('The book was returned successfully')
            this.handleCurrentChange(this.queryParam.page)
          } else {
            this.$message.error('Failed to return the book')
          }
        })
      })
    },

    // Batch return of books
    // handleReturn(row, index) {
    //   this.$confirm('Are you sure you want to return the book?', 'Tip', {
    //     confirmButtonText: 'Sure',
    //     cancelButtonText: 'Cancel',
    //     type: 'warning'
    //   }).then(() => {
    //     returnBook(row.borrowid, row.bookid).then(res => {
    //       if(res === 1) {
    //         this.$message.success('The book was returned successfully')
    //         this.handleCurrentChange(this.queryParam.page)
    //       } else {
    //         this.$message.error('Failed to return the book')
    //       }
    //     })
    //   })
    // },

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
        userid: null,
        username: null,
        bookname: null,
      }
    }
  },
  computed: {
    // Obtain user information
    ...mapGetters(['id','name','roles']),
    roleIsAdmin() {
      if(this.roles[0] === 'admin') return true
      else return false
    }
  },
  watch: {
    'queryParam.userid': {
      immediate: true,
      handler() {
        console.log("I was triggered")
        if (this.roleIsAdmin) {
          this.queryParam.userid = null
        } else {
          this.queryParam.userid = this.id
        }
      }
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
