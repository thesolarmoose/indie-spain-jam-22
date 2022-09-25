using UnityAtoms.BaseAtoms;
using UnityEngine;

namespace DepthLogic
{
    public class MetersUpdater : MonoBehaviour
    {
        [SerializeField] private Transform _target;
        [SerializeField] private FloatVariable _metersVariable;
        [SerializeField] private FloatVariable _depthScale;
        
        private void Update()
        {
            var depth = _target.position.y;
            depth /= _depthScale.Value;
            _metersVariable.Value = -depth;
        }
    }
}