#encoding: utf-8
user = User.create({name: 'admin', 
                    email: 'admin@example.com',
                    password: 'password',
                    password_confirmation: 'password'})

seek1 = Seek.create({company_name: '全球网'})
seek2 = Seek.create({company_name: '义乌全球网实业'})

company1 = Company.create({name: '杭州义商全球网信息技术有限公司',
                           number: '330108000022757',
                           owner_name: '方兴东'})

company2 = Company.create({name: '义乌全球网实业有限公司',
                           number: '330782000019063',
                           owner_name: '方兴东'})

company3 = Company.create({name: '桐庐大奇山郡置业有限公司',
                           number: '330122000025878',
                           owner_name: '俞建午'})

user.seeks << seek1
user.seeks << seek2