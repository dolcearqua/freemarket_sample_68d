module TradingHelper
  def trading_item_users(item)
    @saler_user = User.find(item.saler_id)
    @buyer_user = User.find(item.buyer_id)
  end

  def trading_item_fee(item)
    price = item.price * 0.1 
    @sales_commission = price.floor
    @sales_profit = item.price - @sales_commission
  end

  def sales_price_present?(sales_price)
    if sales_price.present?
      "¥#{sales_price.price.to_s(:delimited)}"
    else
      "¥0"
    end
  end

  def point_present?(point)
    if point.present?
      "P#{point.point.to_s(:delimited)}"
    else
      "P0"
    end
  end

  def trading_status_check(item ,saler_user,  buyer_user)
    case current_user
    when saler_user
      case item.trading_status_id
        when 1
          "商品が購入されました！
          商品を発送してください！"
        when 2
          "受け取り評価をお待ちください"
        when 3
          "受け取り評価がありました！取引評価をしてください"
        when 5
          "この取引はすでに完了しています"
        when 6
          "取引キャンセル申請の通知がありました"
        when 7
          "取引キャンセル申請を送りました"
        when 8
          "取引はキャンセルされました"
      end
    when buyer_user
      case item.trading_status_id
        when 1
          "商品の発送をお待ちください"
        when 2
          "商品が発送されました！
          受け取り評価をしてください！"
        when 3
          "取引相手からの評価をお待ちください"
        when 5
          "この取引はすでに完了しています"
        when 6
          "取引キャンセル申請を送りました"
        when 7
          "取引キャンセル申請の通知がありました"
        when 8
          "取引はキャンセルされました"
      end
    else
      "あなたはこの取引に参加していません"
    end
  end

  def transaction_button(item ,saler_user,  buyer_user)
    case current_user
    when saler_user
      case item.trading_status_id
        when 1
          link_to "商品を発送する", item_trading_path(item, current_user), method: :patch, class: "content__trading__box__btn", remote: true,data: { confirm: '商品発送通知を送信してよろしいですか?',cancel: 'やめる',commit: '承認する', disable_with: "処理中..." }, title: '発送確認'
        when 5
          link_to "この商品を削除する", item_path(item), method: :delete, class: "content__trading__box__btn", data: { confirm: '本当に削除して良いですか?',cancel: 'やめる',commit: '削除する'}, title: '削除確認'
        when 6
          link_to "取引キャンセルを承認する", cancel_item_trading_path(item, current_user), method: :patch, class: "content__trading__box__btn", remote: true, data: { confirm: '取引キャンセルを承認してよろしいですか?',cancel: 'やめる',commit: '承認する', disable_with: "処理中..." }, title: '承認確認'
        when 8
          link_to "再度この商品を出品する", relist_item_trading_path(item, current_user), method: :patch, class: "content__trading__box__btn", data: { disable_with: "処理中..." }
        else
          "取引の進展をお待ちください"
      end
    when buyer_user
      case item.trading_status_id
        when 5
          "取引は完了しました"
        when 7
          link_to "取引キャンセルを承認する", cancel_item_trading_path(item, current_user), method: :patch, class: "content__trading__box__btn", remote: true, data: { confirm: '取引キャンセルを承認してよろしいですか?',cancel: 'やめる',commit: '承認する', disable_with: "処理中..." }, title: '承認確認'
        when 8
          "取引は正常にキャンセルされました"
        else
          "取引の進展をお待ちください"
      end
    end
  end
end
