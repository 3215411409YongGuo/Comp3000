import request from '@/utils/request'

// Obtain the number of books
export function getCount() {
    return request({
        url: '/bookInfo/getCount',
        method: 'get'
    })
}

// Query all book information
export function queryBookInfos() {
    return request({
        url: '/bookInfo/queryBookInfos',
        method: 'get'
    })
}

// Perform page-based query for book information
export function queryBookInfosByPage(params) {
    return request({
        url: '/bookInfo/queryBookInfosByPage',
        method: 'get',
        params
    })
}

// Add book information
export function addBookInfo(data) {
    return request({
        url: '/bookInfo/addBookInfo',
        method: 'post',
        data
    })
}

// Delete book information
export function deleteBookInfo(data) {
    return request({
        url: '/bookInfo/deleteBookInfo',
        method: 'delete',
        data
    })
}

//  Delete some book information
export function deleteBookInfos(data) {
    return request({
        url: '/bookInfo/deleteBookInfos',
        method: 'delete',
        data
    })
}

//  Update book information
export function updateBookInfo(data) {
    return request({
        url: '/bookInfo/updateBookInfo',
        method: 'put',
        data
    })
}
