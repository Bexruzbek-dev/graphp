const String createProduct = """
mutation addProduct(
  \$title: String!, 
  \$price: Float!, 
  \$description: String!, 
  \$categoryId: Float!,
  \$images: [String!]!
) {
    addProduct(
      data: {
        title: \$title, 
        price:  \$price, 
        description: \$description, 
        categoryId: \$categoryId
        images: \$images
      }) {
      id
      title
      price
      description
      images
      category {
        name
      }
    }
}

""";

const String updateProduct = """
mutation UpdateProduct(\$id: ID!, \$title: String, \$price: Float, \$description: String, \$categoryId: ID) {
  updateProduct(id: \$id, input: {
    title: \$title,
    price: \$price,
    description: \$description,
    categoryId: \$categoryId
  }) {
    id
    title
    price
    description
    category {
      name
    }
  }
}
""";

const String deleteProduct = """
mutation DeleteProduct(\$id: ID!) {
  deleteProduct(id: \$id) {
    id
  }
}
""";
