import { INavData } from '@coreui/angular';

export const navItems: INavData[] = [
  {
    name: 'Dashboard',
    url: '/admin/dashboard',
    icon: 'icon-speedometer',
    badge: {
      variant: 'info',
      text: 'NEW'
    }
  },
  {
    title: true,
    name: 'Theme'
  },
  {
    name: 'Colors',
    url: '/admin/theme/colors',
    icon: 'icon-drop'
  },
  {
    name: 'Nhãn hiệu',
    url: '/admin/trademark',
    icon: 'icon-star'
  },
  {
    name: 'Nhà cung cấp',
    url: '/admin/supplier',
    icon: 'icon-handbag'
  },
  {
    name: 'Nhập kho',
    url: '/admin/coupon',
    icon: 'icon-arrow-down-circle'
  },
  {
    name: 'Quản lý đơn hàng',
    url: '/admin/order',
    icon: 'icon-basket'
  },
  {
    name: 'Sản phẩm',
    url: '/product',
    icon: 'icon-rocket',
    children: [
      {
        name: 'Sản phẩm',
        url: '/admin/product/product',
        icon: 'icon-rocket'
      },
      {
        name: 'Hình ảnh sản phẩm',
        url: '/admin/product/product-image',
        icon: 'icon-rocket'
      },
    ]
  },
  {
    name: 'Ngày khuyến mãi',
    url: '/admin/promotion-date',
    icon: 'icon-pencil'
  },
  {
    name: 'Khuyến mãi sản phẩm',
    url: '/admin/product-promotion',
    icon: 'icon-pencil'
  },
  {
    name: 'Tin tức',
    url: '/admin/news',
    icon: 'icon-pencil'
  },
  {
    name: 'Báo cáo',
    url: '/report',
    icon: 'icon-rocket',
    children: [
      {
        name: 'Báo cáo hàng tồn kho',
        url: '/admin/report/inventory-report',
        icon: 'icon-rocket'
      },
      {
        name: 'Báo cáo hóa đơn',
        url: '/admin/report/bill-report',
        icon: 'icon-rocket'
      },
    ]
  },
  {
    name: 'Typography',
    url: '/admin/theme/typography',
    icon: 'icon-pencil'
  },
  {
    title: true,
    name: 'Components'
  },
  {
    name: 'Base',
    url: '/admin/base',
    icon: 'icon-puzzle',
    children: [
      {
        name: 'Cards',
        url: '/admin/base/cards',
        icon: 'icon-puzzle'
      },
      {
        name: 'Carousels',
        url: '/admin/base/carousels',
        icon: 'icon-puzzle'
      },
      {
        name: 'Collapses',
        url: '/admin/base/collapses',
        icon: 'icon-puzzle'
      },
      {
        name: 'Forms',
        url: '/admin/base/forms',
        icon: 'icon-puzzle'
      },
      {
        name: 'Navbars',
        url: '/admin/base/navbars',
        icon: 'icon-puzzle'

      },
      {
        name: 'Pagination',
        url: '/admin/base/paginations',
        icon: 'icon-puzzle'
      },
      {
        name: 'Popovers',
        url: '/admin/base/popovers',
        icon: 'icon-puzzle'
      },
      {
        name: 'Progress',
        url: '/admin/base/progress',
        icon: 'icon-puzzle'
      },
      {
        name: 'Switches',
        url: '/admin/base/switches',
        icon: 'icon-puzzle'
      },
      {
        name: 'Tables',
        url: '/admin/base/tables',
        icon: 'icon-puzzle'
      },
      {
        name: 'Tabs',
        url: '/admin/base/tabs',
        icon: 'icon-puzzle'
      },
      {
        name: 'Tooltips',
        url: '/admin/base/tooltips',
        icon: 'icon-puzzle'
      }
    ]
  },
  {
    name: 'Buttons',
    url: '/buttons',
    icon: 'icon-cursor',
    children: [
      {
        name: 'Buttons',
        url: '/admin/buttons/buttons',
        icon: 'icon-cursor'
      },
      {
        name: 'Dropdowns',
        url: '/admin/buttons/dropdowns',
        icon: 'icon-cursor'
      },
      {
        name: 'Brand Buttons',
        url: '/admin/buttons/brand-buttons',
        icon: 'icon-cursor'
      }
    ]
  },
  {
    name: 'Charts',
    url: '/admin/charts',
    icon: 'icon-pie-chart'
  },
  {
    name: 'Icons',
    url: '/admin/icons',
    icon: 'icon-star',
    children: [
      {
        name: 'CoreUI Icons',
        url: '/admin/icons/coreui-icons',
        icon: 'icon-star',
        badge: {
          variant: 'success',
          text: 'NEW'
        }
      },
      {
        name: 'Flags',
        url: '/admin/icons/flags',
        icon: 'icon-star'
      },
      {
        name: 'Font Awesome',
        url: '/admin/icons/font-awesome',
        icon: 'icon-star',
        badge: {
          variant: 'secondary',
          text: '4.7'
        }
      },
      {
        name: 'Simple Line Icons',
        url: '/admin/icons/simple-line-icons',
        icon: 'icon-star'
      }
    ]
  },
  {
    name: 'Notifications',
    url: '/admin/notifications',
    icon: 'icon-bell',
    children: [
      {
        name: 'Alerts',
        url: '/admin/notifications/alerts',
        icon: 'icon-bell'
      },
      {
        name: 'Badges',
        url: '/admin/notifications/badges',
        icon: 'icon-bell'
      },
      {
        name: 'Modals',
        url: '/admin/notifications/modals',
        icon: 'icon-bell'
      }
    ]
  },
  {
    name: 'Widgets',
    url: '/admin/widgets',
    icon: 'icon-calculator',
    badge: {
      variant: 'info',
      text: 'NEW'
    }
  }, 
  {
    divider: true
  },
  {
    title: true,
    name: 'Extras',
  },
  {
    name: 'Pages',
    url: '/pages',
    icon: 'icon-star',
    children: [
      {
        name: 'Login',
        url: '/login',
        icon: 'icon-star'
      },
      {
        name: 'Register',
        url: '/register',
        icon: 'icon-star'
      },
      {
        name: 'Error 404',
        url: '/404',
        icon: 'icon-star'
      },
      {
        name: 'Error 500',
        url: '/500',
        icon: 'icon-star'
      }
    ]
  },
  {
    name: 'Disabled',
    url: '/admin/dashboard',
    icon: 'icon-ban',
    badge: {
      variant: 'secondary',
      text: 'NEW'
    },
    attributes: { disabled: true },
  },
  {
    name: 'Download CoreUI',
    url: 'http://coreui.io/angular/',
    icon: 'icon-cloud-download',
    class: 'mt-auto',
    variant: 'success',
    attributes: { target: '_blank', rel: 'noopener' }
  },
  {
    name: 'Try CoreUI PRO',
    url: 'http://coreui.io/pro/angular/',
    icon: 'icon-layers',
    variant: 'danger',
    attributes: { target: '_blank', rel: 'noopener' }
  }
];
