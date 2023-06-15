export interface ErrorWithSubErrors {
    status: string
    message: string
    path: string
    statusCode: number
    date: string
    subErrors: SubError[]
}

export interface SubError {
    object: string
    message: string
    field: string
    rejectedValue: string
}
