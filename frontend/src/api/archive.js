import request from '@/utils/request'

// 获取档案列表
export function getArchiveList(params) {
  return request({
    url: '/archive/list',
    method: 'get',
    params
  })
}

// 获取档案详情
export function getArchiveDetail(id) {
  return request({
    url: `/archive/${id}`,
    method: 'get'
  })
}

// 创建档案
export function createArchive(data) {
  return request({
    url: '/archive',
    method: 'post',
    data
  })
}

// 更新档案
export function updateArchive(id, data) {
  return request({
    url: `/archive/${id}`,
    method: 'put',
    data
  })
}

// 删除档案
export function deleteArchive(id) {
  return request({
    url: `/archive/${id}`,
    method: 'delete'
  })
}

// 上传文件
export function uploadFile(file) {
  const formData = new FormData()
  formData.append('file', file)
  return request({
    url: '/archive/upload',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// OCR识别
export function ocrRecognize(data) {
  return request({
    url: '/archive/ocr',
    method: 'post',
    data
  })
}
