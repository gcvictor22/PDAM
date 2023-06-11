export interface GetLoginDto {
    id: string
    userName: string
    fullName: string
    imgPath: string
    followers: number
    countOfPosts: number
    verified: boolean
    followedByUser: boolean
    createdAt: string
    token: string
    refreshToken: string
}
