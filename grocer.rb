def consolidate_cart(cart)
  new_cart = Hash.new(0)

  cart.each do |items|
    items.each do |item, info|
      if new_cart.has_key?(item)
        new_cart[item][:count] += 1
      else
        new_cart[item] = info
        new_cart[item][:count] = 1
      end
    end
  end
  new_cart
end

def apply_coupons(cart, coupons)

  if coupons.empty?
    return cart
  end

  new_cart = cart.clone

    cart.each do |item, attributes|
      coupons.each do |coupon|

        if item == coupon[:item] && attributes[:count] >= coupon[:num]
          coup_item = "#{item.upcase} W/COUPON"

          if new_cart.keys.include?(coup_item)
             new_cart[coup_item][:count] += 1
          else
            new_cart[coup_item] = {}
            new_cart[coup_item][:price] =  coupon[:cost]
            new_cart[coup_item][:clearance] =  attributes[:clearance]
            new_cart[coup_item][:count] = 1
          end
          new_cart[item][:count] = attributes[:count] - coupon[:num]
        end
      end
    end
    new_cart
  end

def apply_clearance(cart)
  cart.map do |item, info|
     if info[:clearance] == true
       info[:price] = (info[:price] * 4) / 5
     end
   end
  cart
 end

def checkout(cart, coupons)
  checkout_cart = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
  total = 0

  checkout_cart.each do |item, info|
    total += info[:price] * info[:count]
  end

    if total > 100
      return (total - (total * 0.1))
    else
      return total
    end
  end
