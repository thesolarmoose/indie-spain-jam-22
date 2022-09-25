using UnityEngine;
using UnityEngine.Events;
using Utils.Extensions;

namespace DefaultNamespace
{
    public class TriggerCallbackOnCollision : MonoBehaviour
    {
        [SerializeField] private LayerMask _collisionMask;
        
        [SerializeField] private UnityEvent _onCollision;

        private void OnTriggerEnter2D(Collider2D other)
        {
            if (_collisionMask.IsLayerInMask(other.gameObject.layer))
            {
                _onCollision.Invoke();
            }
        }
    }
}