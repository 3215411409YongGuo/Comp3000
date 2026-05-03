import request from '@/utils/request'

// Obtain the number of borrowings
export function getCount() {
    return request({
        url: '/borrow/getCount',
        method: 'get'
    })
}

// Query all borrowing information
export function queryBorrows() {
    return request({
        url: '/borrow/queryBorrows',
        method: 'get'
    })
}

// Perform page-based query for borrowing information
export function queryBorrowsByPage(params) {
    return request({
        url: '/borrow/queryBorrowsByPage',
        method: 'get',
        params
    })
}

// Add borrowing information
export function addBorrow(data) {
    return request({
        url: '/borrow/addBorrow',
        method: 'post',
        data
    })
}

// Delete borrowing information
export function deleteBorrow(data) {
    return request({
        url: '/borrow/deleteBorrow',
        method: 'delete',
        data
    })
}

//  Delete some borrowing information
export function deleteBorrows(data) {
    return request({
        url: '/borrow/deleteBorrows',
        method: 'delete',
        data
    })
}

//  Update borrowing information
export function updateBorrow(data) {
    return request({
        url: '/borrow/updateBorrow',
        method: 'put',
        data
    })
}

// Borrowing books
export function borrowBook(userid, bookid) {
    return request({
        url: '/borrow/borrowBook',
        method: 'post',
        params: {
            userid,
            bookid
        }
    })
}

// Return the books
export function returnBook(borrowid, bookid) {
    return request({
        url: '/borrow/returnBook',
        method: 'post',
        params: {
            borrowid,
            bookid
        }
    })
}
