# 每天同步apollo的数据
every 1.day, :at => '11:30 pm' do
  runner "SkyeyeApollo::Apollo::Company.sync"
end
