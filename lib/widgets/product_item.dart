import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String imageUrl;
  // final String title;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: FadeInImage(
            placeholder:
                AssetImage('assets/images/product_image_placeholder.png'),
            image: NetworkImage(product.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Consumer2<Product, Auth>(
            builder: (_, product, auth, __) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_outline),
              onPressed: () {
                product.toggleFavorite(auth.token, auth.userId);
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(
                product.id,
                product.title,
                product.price,
                product.imageUrl,
              );
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added item to the cart!',
                  ),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () => cart.removeSingleItem(product.id),
                    textColor: Colors.blue,
                  ),
                  duration: Duration(seconds: 3),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
