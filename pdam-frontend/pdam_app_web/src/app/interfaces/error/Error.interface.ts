import Swal from "sweetalert2"

export interface Error {
    status: string
    message: string
    path: string
    statusCode: number
    date: string
}

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

export class CaptureError {
    constructor() { }

    static catchError(error: any) {
        if (error.error.message === "Validation error. Please check the sublist.") {
            const aux = error.error as ErrorWithSubErrors;
            let auxText = '';

            for (const e of aux.subErrors) {
                auxText += `<li>${e.message}</li><br>`;
            }

            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: auxText,
                html: `<ul>${auxText}</ul>`
            });
        }else {
            var auxError = error.error as Error;
            Swal.fire({
              icon: 'error',
              title: 'Error',
              text: auxError.message,
              timer: 1500,
              showConfirmButton: false,
            })
        }
    }
}